//
//  CoreNetwork.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/09/2025.
//

import Foundation
import os.log

// MARK: - Network Errors

public enum NetworkError: Error, Equatable {
    case expiredTokenMsg
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
    case noConnection
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL(let errorMsg):               return NSLocalizedString("Bad Url", comment: errorMsg)
        case .apiError(_, let errorMsg):          return errorMsg
        case .invalidJSON(let errorMsg):          return errorMsg
        case .unauthorized(_, let errorMsg):      return errorMsg
        case .badRequest(_, let errorMsg):        return errorMsg
        case .serverError(_, let errorMsg):       return errorMsg
        case .noResponse(let errorMsg):           return errorMsg
        case .unableToParseData(let errorMsg):    return errorMsg
        case .unknown(_, let errorMsg):           return errorMsg
        case .expiredTokenMsg:                    return "login_expired"
        case .noConnection:                       return "no_connection"
        }
    }
}

// MARK: - HTTP Method

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete  = "DELETE"
    case get     = "GET"
    case head    = "HEAD"
    case options = "OPTIONS"
    case patch   = "PATCH"
    case post    = "POST"
    case put     = "PUT"
    case trace   = "TRACE"
}

// MARK: - TargetType1

protocol TargetType1 {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    // Existing dictionary parameters
    var parameters: [String: Any]? { get }
    // New: optional top-level array payload
    var arrayParameters: [Any]? { get }
    var timeoutInterval: TimeInterval? { get }
}

extension TargetType1 {
    var timeoutInterval: TimeInterval? { nil }
    var baseURL: URL { URL(string: Constants.apiURL)! }
    var requestURL: URL { baseURL.appendingPathComponent(path) }
    var headers: [String: String]? {
        var header: [String: String] = [
            "Accept": "application/json"
        ]
        if let token = Helper.shared.getUser()?.token, !token.isEmpty {
            header["Authorization"] = "Bearer " + token
        }
        return header
    }
    // Default nil so existing services don’t need to implement it
    var arrayParameters: [Any]? { nil }
    
}

// MARK: - Service Protocol

protocol AsyncAwaitNetworkServiceProtocol {
    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T?
    func uploadMultipart<T: Codable>(_ target: TargetType1, parts: [MultipartFormDataPart], responseType: T.Type) async throws -> T?
}

// MARK: - Service Implementation

final class AsyncAwaitNetworkService: AsyncAwaitNetworkServiceProtocol {

    static let shared = AsyncAwaitNetworkService()

    private let session: URLSession
    private let logger = Logger(subsystem: "com.sehaty.network", category: "networking")

    private let defaultTimeout: TimeInterval = 30.0
    private let maxRetryCount = 2

    private init(session: URLSession = AsyncAwaitNetworkService.makeDefaultSession()) {
        self.session = session
    }

    private static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config)
    }

    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }

        let url = target.requestURL
        var lastError: Error?

        for attempt in 1...maxRetryCount {
            let request = try buildRequest(for: target, url: url)
            logRequest(request, attempt: attempt)

            do {
                let start = Date()
                let (data, response) = try await session.data(for: request)
                let duration = Date().timeIntervalSince(start)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.noResponse("Invalid response object")
                }
                logResponse(httpResponse, data: data, duration: duration)

                if (200..<300).contains(httpResponse.statusCode), data.isEmpty {
                    return nil
                }

                if !(200..<300).contains(httpResponse.statusCode) {
                    try throwHTTPError(httpResponse: httpResponse, data: data)
                }

                let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") ?? ""
                if !isJSONContentType(contentType), !data.isEmpty {
                    do {
                        return try decodeResponse(data, responseType)
                    } catch {
                        throw NetworkError.invalidJSON("Unexpected Content-Type: \(contentType)")
                    }
                }

                return try decodeResponse(data, responseType)

            } catch let cancelError as CancellationError {
                logger.info("Request was cancelled \(cancelError).")
                throw cancelError
            } catch let urlErr as URLError where urlErr.code == .cancelled {
                logger.info("Request was cancelled (URLError.cancelled).")
                throw urlErr
            } catch {
                let mapped = mapToNetworkError(error: error)
                lastError = mapped
                logger.warning("Attempt \(attempt) failed: \(mapped.localizedDescription)")
                if attempt < maxRetryCount,
                   shouldRetry(error: mapped, statusCode: (error as? URLError)?.errorCode, method: target.method) {
                    let backoff = backoffDelay(for: attempt)
                    try? await Task.sleep(nanoseconds: backoff)
                    continue
                } else {
                    throw mapped
                }
            }
        }

        throw lastError ?? NetworkError.unknown(code: -1, error: "Unknown failure")
    }

    // MARK: - Multipart Upload

    func uploadMultipart<T: Codable>(
        _ target: TargetType1,
        parts: [MultipartFormDataPart],
        responseType: T.Type
    ) async throws -> T? {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let url = target.requestURL

        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.timeoutInterval = target.timeoutInterval ?? defaultTimeout

        // Merge headers and ensure Authorization if available
        var mergedHeaders = target.headers ?? [:]
        if mergedHeaders["Authorization"] == nil,
           let token = Helper.shared.getUser()?.token, !token.isEmpty {
            mergedHeaders["Authorization"] = "Bearer \(token)"
        }
        mergedHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        if mergedHeaders["Accept"] == nil {
            mergedHeaders["Accept"] = "application/json"
        }
        mergedHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Build multipart body
        request.httpBody = createMultipartBody(parts: parts, boundary: boundary)

        logRequest(request, attempt: 1)

        let start = Date()
        let (data, response) = try await session.data(for: request)
        let duration = Date().timeIntervalSince(start)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse("Invalid response object")
        }

        logResponse(httpResponse, data: data, duration: duration)

        if (200..<300).contains(httpResponse.statusCode), data.isEmpty {
            return nil
        }

        if !(200..<300).contains(httpResponse.statusCode) {
            try throwHTTPError(httpResponse: httpResponse, data: data)
        }

        let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") ?? ""
        if !isJSONContentType(contentType), !data.isEmpty {
            do {
                return try decodeResponse(data, responseType)
            } catch {
                throw NetworkError.invalidJSON("Unexpected Content-Type: \(contentType)")
            }
        }

        return try decodeResponse(data, responseType)
    }

    private func createMultipartBody(parts: [MultipartFormDataPart], boundary: String) -> Data {
        var body = Data()

        for part in parts {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            if let filename = part.filename,
               let mimeType = part.mimeType,
               let data = part.data {
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            } else if let data = part.data {
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    // MARK: - Request Building

    private func buildRequest(for target: TargetType1, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.timeoutInterval = target.timeoutInterval ?? defaultTimeout

        var mergedHeaders = target.headers ?? [:]
        if mergedHeaders["Authorization"] == nil,
           let token = Helper.shared.getUser()?.token, !token.isEmpty {
            mergedHeaders["Authorization"] = "Bearer \(token)"
        }
        mergedHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Encode parameters
        if let arrayBody = target.arrayParameters, !arrayBody.isEmpty {
            // Top-level array body (POST/PUT/PATCH)
            switch target.method {
            case .post, .put, .patch:
                request.httpBody = try JSONSerialization.data(withJSONObject: arrayBody, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if request.value(forHTTPHeaderField: "Accept") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                }
            case .get, .head, .delete:
                // GET/HEAD/DELETE cannot have body; ignore array body on these methods.
                break
            default:
                break
            }
        } else if let parameters = target.parameters, !parameters.isEmpty {
            switch target.method {
            case .get, .head, .delete:
                if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    let items = buildQueryItems(from: parameters)
                    components.queryItems = (components.queryItems ?? []) + items
                    request.url = components.url
                }
            case .post, .put, .patch:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if request.value(forHTTPHeaderField: "Accept") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                }
            default:
                break
            }
        }

        return request
    }

    // MARK: - Decoding

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private func decodeResponse<T: Codable>(_ data: Data, _ type: T.Type) throws -> T? {
        if let wrapper = try? jsonDecoder.decode(BaseResponse<T>.self, from: data) {
            let isSuccess: Bool = {
                if let success = wrapper.success { return success }
                if let code = wrapper.messageCode { return (200..<300).contains(code) }
                return true
            }()

            if isSuccess {
                return wrapper.data
            } else {
                throw NetworkError.unknown(
                    code: wrapper.messageCode ?? -1,
                    error: wrapper.message ?? "Unknown error"
                )
            }
        }
        return try jsonDecoder.decode(T.self, from: data)
    }

    // MARK: - HTTP Error Mapping

    private func throwHTTPError(httpResponse: HTTPURLResponse, data: Data) throws -> Never {
        let status = httpResponse.statusCode
        let serverMessage: String = {
            if let decoded = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                return decoded.message
            } else {
                return String(data: data, encoding: .utf8) ?? "HTTP \(status)"
            }
        }()

        switch status {
        case 401:
            let errorHeader = httpResponse.value(forHTTPHeaderField: "Www-Authenticate")
            throw NetworkError.unauthorized(code: status, error: errorHeader ?? serverMessage)
        case 400..<500:
            if let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") {
                throw NetworkError.badRequest(code: status, error: "\(serverMessage) (Retry-After: \(retryAfter))")
            } else {
                throw NetworkError.badRequest(code: status, error: serverMessage)
            }
        case 500..<600:
            throw NetworkError.serverError(code: status, error: serverMessage.isEmpty ? "Server error" : serverMessage)
        default:
            throw NetworkError.unknown(code: status, error: serverMessage)
        }
    }

    private func mapToNetworkError(error: Error) -> NetworkError {
        if let net = error as? NetworkError { return net }
        if let urlErr = error as? URLError {
            switch urlErr.code {
            case .notConnectedToInternet: return .noConnection
            case .timedOut:               return .apiError(code: urlErr.errorCode, error: "Request timed out")
            case .networkConnectionLost:  return .apiError(code: urlErr.errorCode, error: "Network connection lost")
            case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                return .apiError(code: urlErr.errorCode, error: "Cannot reach host")
            case .cancelled:              return .unknown(code: urlErr.errorCode, error: "Cancelled")
            default:                      return .unknown(code: urlErr.errorCode, error: urlErr.localizedDescription)
            }
        }
        return .unknown(code: -1, error: error.localizedDescription)
    }

    private func shouldRetry(error: NetworkError, statusCode: Int?, method: HTTPMethod) -> Bool {
        let idempotent = (method == .get || method == .head || method == .options || method == .delete)
        guard idempotent else { return false }

        switch error {
        case .serverError: return true
        case .apiError(let code, _):
            return code == URLError.timedOut.rawValue || code == URLError.networkConnectionLost.rawValue
        case .noConnection: return true
        default: return false
        }
    }

    private func backoffDelay(for attempt: Int) -> UInt64 {
        let base: Double = 0.5
        let max: Double = 2.0
        let delay = min(max, base * pow(2.0, Double(attempt - 1)))
        let jitter = Double.random(in: 0...(delay * 0.2))
        return UInt64((delay + jitter) * 1_000_000_000)
    }

    private func buildQueryItems(from parameters: [String: Any]) -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        func append(name: String, value: Any) {
            switch value {
            case let v as String:
                items.append(URLQueryItem(name: name, value: v))
            case let v as CustomStringConvertible:
                items.append(URLQueryItem(name: name, value: v.description))
            case let arr as [Any]:
                for element in arr { append(name: name, value: element) }
            case let dict as [String: Any]:
                for (k, v) in dict { append(name: "\(name).\(k)", value: v) }
            default:
                items.append(URLQueryItem(name: name, value: "\(value)"))
            }
        }

        for (key, value) in parameters {
            append(name: key, value: value)
        }
        return items
    }

    private func isJSONContentType(_ value: String) -> Bool {
        let lower = value.lowercased()
        return lower.contains("application/json") || lower.contains("+json")
    }

    private func logRequest(_ request: URLRequest, attempt: Int) {
        #if DEBUG
        var lines: [String] = []
        lines.append("=== Request [Attempt \(attempt)] ===")
        lines.append("URL: \(request.url?.absoluteString ?? "nil")")
        lines.append("Method: \(request.httpMethod ?? "nil")")
        let safeHeaders = request.allHTTPHeaderFields?.filter { $0.key.lowercased() != "authorization" } ?? [:]
        lines.append("Headers: \(safeHeaders)")
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            lines.append("Body: \(bodyString)")
        }
        lines.append("=========================")
        print(lines.joined(separator: "\n"))
        #endif
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data?, duration: TimeInterval) {
        #if DEBUG
        var lines: [String] = []
        lines.append("=== Response ===")
        lines.append("url: \(response.url?.absoluteString ?? "nil")")
        lines.append("Status Code: \(response.statusCode)")
        lines.append("Duration: \(String(format: "%.2f", duration))s")
        lines.append("Headers: \(response.allHeaderFields)")
        if let data = data, let body = String(data: data, encoding: .utf8) {
            lines.append("Body: \(body.prefix(1000))...")
        }
        lines.append("================")
        print(lines.joined(separator: "\n"))
        #endif
    }
}

// Multipart section unchanged below...

