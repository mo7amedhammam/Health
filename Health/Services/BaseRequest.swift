//
//  BaseRequest.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//
import Foundation
import UIKit
import Alamofire
//import Combine

func buildparameter(paramaters:parameterType)->([String:Any],ParameterEncoding){
    switch paramaters{
    case .plainRequest:
        return ([:],URLEncoding.default)
    case .parameterRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)
    case .BodyparameterRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)
        
    case .parameterdGetRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)

    }
}


@available(iOS 13.0, *)
final class BaseNetwork{
    static let shared = BaseNetwork()
    
    // MARK: - (Combine) CAll API with promiseKit
    //    static func CallApi<T: TargetType,M:Codable>(_ target: T,_ Model:M.Type) -> AnyPublisher<M, NetworkError> {
    //          return Future<M, NetworkError>{ promise in
    //              let parameters = buildparameter(paramaters: target.parameter)
    //              let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
    //              print(target.requestURL)
    //              print(target.method)
    //              print(parameters)
    //              print(headers ?? [:])
    //              AF.request(target.requestURL,method: target.method ,parameters:parameters.0,encoding:parameters.1,headers:headers)
    //                  .responseDecodable(of: M.self, decoder: JSONDecoder()){ response in
    ////                      print(response)
    ////                      print(response.response?.statusCode)
    //                     if response.response?.statusCode == 401{
    //                          promise(.failure(.unauthorized(code: response.response?.statusCode ?? 0, error: NetworkError.expiredTokenMsg.errorDescription ?? "")))
    //                      }else{
    //                          switch response.result {
    //                          case .success(let model):
    //                              promise(.success(model))
    //                          case .failure(let error):
    ////                              print(error.localizedDescription)
    //                              promise(.failure(.unknown(code: 0, error: error.localizedDescription)))
    //                          }
    //                      }
    //                  }
    //
    //          }.eraseToAnyPublisher()
    //      }
    
    static func asyncCallApi<T: TargetType, M: Codable>(
        _ target: T,
        _ modelType: M.Type
    ) async throws -> M {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }
        let parameters = buildparameter(paramaters: target.parameter)
        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
        let (requestURL, method, parametersarr, encoding) = (target.requestURL, target.method, parameters.0, parameters.1)
        
        print("\(requestURL)",parameters,method,headers ?? [:])
//        print(parameters)
//        print(headers ?? [:])

        let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<M, Error>) in
            AF.request(requestURL, method: method, parameters: parametersarr, encoding: encoding, headers: headers)
                .responseDecodable(of: M.self, decoder: JSONDecoder()) { dataResponse in
                    do {
                        guard let responsecode = dataResponse.response?.statusCode else {
                            throw NetworkError.unknown(code: 0, error: "No response code")
                        }
                        switch dataResponse.result {
                        case .success(let model):
                            continuation.resume(returning: model)
                        case .failure(let error):
                            if responsecode == 401 {
                                continuation.resume(throwing: NetworkError.unauthorized(code: responsecode, error: NetworkError.expiredTokenMsg.localizedDescription))
                            } else {
                                continuation.resume(throwing: NetworkError.unknown(code: responsecode, error: error.localizedDescription))
                            }
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
        }
        
        return response
    }

 
            

    static func callApi<T: TargetType, M: Codable>(
        _ target: T,
        _ modelType: M.Type,
        completion: @escaping (Result<M, NetworkError>) -> Void
    ) {
        guard Helper.shared.isConnectedToNetwork() else{
            completion(.failure(NetworkError.noConnection))
            return
        }
        
        let parameters = buildparameter(paramaters: target.parameter)
        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
        
        print("requestURL",target.requestURL)
        print("headers",headers ?? [:])
        print("parameters",parameters)
        print("--Target--",target)

        AF.request(target.requestURL, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: headers)
            .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
                guard let responsecode = response.response?.statusCode else{return}
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    if responsecode == 401{
                        completion(.failure(.unauthorized(code: responsecode, error: NetworkError.expiredTokenMsg.localizedDescription)))
                    }else{
                        completion(.failure(.unknown(code: responsecode, error: error.localizedDescription)))
                    }
                }
                
            }
    }
    
    private let session: Session
        
        private init() {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            self.session = Session(configuration: configuration)
        }
    

    func request<T: TargetType, M: Codable>(_ target: T, _ Model: M.Type) async throws -> M {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }
        
        let url = try target.asURL()
        
        let parameters = buildparameter(paramaters: target.parameter)
        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
        
        print(target.requestURL)
        print(target.method)
        print(parameters)
        print(headers ?? [:])

        let response = try await session.request(
            url,
            method: target.method,
            parameters: parameters.0,
            encoding: parameters.1,
            headers: headers
        )
        .validate(statusCode: 200..<502) // Validate status codes in the 200 range
        .serializingDecodable(M.self) // Decode to BaseResponse
        .value
        
        print("response : \n", response)
        
        // Check the success property of the BaseResponse
//        if let success = response.success, success == false {
//            throw NetworkError.unknown(
//                code: response.messageCode ?? 0,
//                error: response.message ?? "Unknown error"
//            )
//        }
        
        // Return the data if there's no error
//        guard let data = response.data else {
//            throw NetworkError.unknown(
//                code: response.messageCode ?? 0,
//                error: response.message ?? "No data received"
//            )
//        }
        
        return response
    }
    
    
    // MARK: - (Combine) CAll API with promiseKit
    //    static func uploadApi<T: TargetType,M:Codable>(_ target: T,_ Model:M.Type) -> AnyPublisher<M, NetworkError> {
    //          return Future<M, NetworkError>{ promise in
    //              let parameters = buildparameter(paramaters: target.parameter)
    //              let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
    //              print(target.requestURL)
    //              print(target.method)
    //              print(parameters)
    //              print(headers ?? [:])
    //              AF.upload(multipartFormData: { (multipartFormData) in
    //                  for (key , value) in parameters.0{
    //                      if let tempImg = value as? UIImage{
    //                          if let data = tempImg.jpegData(compressionQuality: 0.8), (tempImg.size.width ) > 0 {
    //                                  //be carefull and put file name in withName parmeter
    //                                  multipartFormData.append(data, withName: key , fileName: "file.jpeg", mimeType: "image/jpeg")
    //                              }
    //                      }
    //
    //                      if let tempStr = value as? String {
    //                          multipartFormData.append(tempStr.data(using: .utf8)!, withName: key)
    //                      }
    //                      if let tempInt = value as? Int {
    //                          multipartFormData.append("\(tempInt)".data(using: .utf8)!, withName: key)
    //                      }
    //                      if let tempArr = value as? NSArray{
    //                          tempArr.forEach({ element in
    //                              let keyObj = key + "[]"
    //                              if let string = element as? String {
    //                                  multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
    //                              } else
    //                              if let num = element as? Int {
    //                                  let value = "\(num)"
    //                                  multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
    //                              }
    //                          })
    //                      }
    //                  }
    //              },
    //                        to: target.requestURL,
    //                        method: target.method,
    //                        headers: headers
    //              )
    //                  .responseDecodable(of: M.self, decoder: JSONDecoder()){ response in
    //                      print(response)
    //                      switch response.result {
    //                      case .success(let model):
    //                          promise(.success(model))
    //                      case .failure(let error):
    //                          promise(.failure(.unknown(code: 0, error: error.localizedDescription)))
    //                      }
    //                  }
    //
    //          }.eraseToAnyPublisher()
    //      }
    
    // MARK: - (Completion handler) CAll API with promiseKit
    static func uploadApi<T: TargetType, M: Codable>(
        _ target: T,
        _ Model: M.Type,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<M, NetworkError>) -> Void
    ) {
        guard Helper.shared.isConnectedToNetwork() else{
            completion(.failure(NetworkError.noConnection))
            return
        }
        let parameters = buildparameter(paramaters: target.parameter)
        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
        print(target.requestURL)
        print(target.method)
        print(parameters)
        print(headers ?? [:])
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key , value) in parameters.0 {
                
                if let tempImg = value as? UIImage {
                    if let data = tempImg.jpegData(compressionQuality: 0.9), (tempImg.size.width ) > 0 {

//                    if let data = tempImg.pngData(), (tempImg.size.width ) > 0 {
                        // Be careful and put the file name in withName parameter
                        multipartFormData.append(data, withName: key , fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
                }
                else if let tempURL = value as? URL {
                    if let data = try? Data(contentsOf: tempURL), tempURL.pathExtension.lowercased() == "pdf" {
                        multipartFormData.append(data, withName: key, fileName: "file.pdf", mimeType: "application/pdf")
                    }
                }
                else if let tempStr = value as? String {
                    multipartFormData.append(tempStr.data(using: .utf8)!, withName: key)
                }
                else if let tempInt = value as? Int {
                    multipartFormData.append("\(tempInt)".data(using: .utf8)!, withName: key)
                }
                else if let tempArr = value as? NSArray {
                    tempArr.forEach { element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    }
                }
            }
        },
                  to: target.requestURL,
                  method: target.method,
                  headers: headers
        )
        .uploadProgress { progress in
            let completedProgress = progress.fractionCompleted
            progressHandler(completedProgress)
            print("progress: %.0f%% \(completedProgress)")
        }
        .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
            print(response)
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(.unknown(code: 0, error: error.localizedDescription)))
            }
        }
    }
    
    // -- Download File --
    static func downloadFile(
        from sourceURL: URL,
        to destinationURL: URL,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(sourceURL, to: destination)
            .downloadProgress { progress in
                let completedProgress = progress.fractionCompleted
                progressHandler(completedProgress)
            }
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}





protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ target: TargetType1, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) //closure
}

final class NetworkService1: NetworkServiceProtocol {
    static let shared = NetworkService1()

    private init() {}

    func request<T: Decodable>(_ target: TargetType1, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        // Check network connectivity
        guard Helper.shared.isConnectedToNetwork() else {
            completion(.failure(.noConnection))
            return
        }

        // Construct the URL
        let url = target.baseURL.appendingPathComponent(target.path)

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue

        // Add headers
        if let headers = target.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // Add parameters
        if let parameters = target.parameters {
            switch target.method {
            case .get:
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                if let urlWithQuery = urlComponents?.url {
                    request.url = urlWithQuery
                }
            case .post, .put, .patch:
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.setValue("Accept", forHTTPHeaderField: "multipart/form-data")
                if let token = Helper.shared.getUser()?.token {
                    request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
                }
            default:
                break
            }
        }

        // Log the request (for debugging)
        logRequest(request)

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidJSON(error?.localizedDescription ?? "invalid response")))
                return
            }
            if let error = error {
                completion(.failure(.unknown(code: httpResponse.statusCode, error: error.localizedDescription)))
                return
            }
            
            // Log the response (for debugging)
            self.logResponse(httpResponse, data: data)

            // Handle status codes
            switch httpResponse.statusCode {
            case 200..<500:
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(.unableToParseData(error.localizedDescription)))
                    }
                } else {
                    completion(.failure(.invalidJSON(error?.localizedDescription ?? "invalid response")))
                }
//            case 401:
//                completion(.failure(.unauthorized(code: httpResponse.statusCode, error: error?.localizedDescription ?? "Unauthorized")))
            default:
                completion(.failure(.serverError(code: httpResponse.statusCode, error: error?.localizedDescription ?? "error") ))
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func logRequest(_ request: URLRequest) {
        print("=== Request ===")
        print("URL: \(request.url?.absoluteString ?? "Invalid URL")")
        print("Method: \(request.httpMethod ?? "No Method")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("===============")
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data?) {
        print("=== Response ===")
        print("Status Code: \(response.statusCode)")
        print("Headers: \(response.allHeaderFields)")
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Body: \(dataString)")
        }
        print("================")
    }
}

//protocol AsyncAwaitNetworkServiceProtocol {
//    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? //async/await
//}
//
//final class AsyncAwaitNetworkService: AsyncAwaitNetworkServiceProtocol {
//    static let shared = AsyncAwaitNetworkService()
//    private init() {}
//
//    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? {
//        // Check network connectivity
//        guard Helper.shared.isConnectedToNetwork() else {
//            throw NetworkError.noConnection
//        }
//
//        // Construct URL
//        let url = target.baseURL.appendingPathComponent(target.path)
//        var request = URLRequest(url: url)
//        request.httpMethod = target.method.rawValue
//
//        // Set headers
//        if let headers = target.headers {
//            for (key, value) in headers {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//
//        // Add Authorization
//        if let token = Helper.shared.getUser()?.token {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//
//        // Add parameters
//        if let parameters = target.parameters {
//            switch target.method {
//            case .get:
//                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
//                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//                    request.url = urlComponents.url
//                }
//            case .post, .put, .patch:
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            default:
//                break
//            }
//        }
//
//        logRequest(request)
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw NetworkError.invalidJSON("Invalid response object")
//            }
//
//            logResponse(httpResponse, data: data)
//
//            switch httpResponse.statusCode {
//            case 200..<300:
//                do {
////                    print("httpResponse",httpResponse)
////                    print("data",data)
////                    print("JSONDecoder().decode(T.self, from: data)",try JSONDecoder().decode(T.self, from: data))
//                    
//                                              // First try to decode as ApiResponse
//                                              if let wrapper = try? JSONDecoder().decode(BaseResponse<T>.self, from: data) {
//                                                  return wrapper.data
//                                              }
//                    
//                                              // Fall back to direct decoding if not wrapped
//                                              return try JSONDecoder().decode(T.self, from: data)
//                    
////                    ------------------------------
////                    // First try to decode as BaseResponse
////                     if let wrapper = try? JSONDecoder().decode(BaseResponse<T>.self, from: data) {
////                         // Safely handle the optional data property
////                         guard let responseData = wrapper.data else {
////                             throw NetworkError.invalidJSON("Response data is nil")
////                         }
////                         return responseData
////                     }
////                     
////                     // Fall back to direct decoding if not wrapped
////                     do {
////                         let directResult = try JSONDecoder().decode(T.self, from: data)
////                         print("Direct decoding result:", directResult)
////                         return directResult
////                     } catch {
////                         print("Direct decoding failed:", error)
////                         throw NetworkError.unableToParseData("Failed to decode response: \(error.localizedDescription)")
////                     }
////                    -------------------------------
//                } catch {
//                          print("Decoding error details:", error)
//                          throw NetworkError.unableToParseData(error.localizedDescription)
//                      }
//
//            case 401:
//                throw NetworkError.unauthorized(code: httpResponse.statusCode, error: "Unauthorized")
//
//            case 400..<500:
//                throw NetworkError.unknown(code: httpResponse.statusCode, error: "Client Error")
//
//            case 500..<600:
//                throw NetworkError.serverError(code: httpResponse.statusCode, error: "Server Error")
//
//            default:
//                throw NetworkError.unknown(code: httpResponse.statusCode, error: "Unhandled status code")
//            }
//        } catch {
//            if let error = error as? NetworkError {
//                throw error
//            } else {
//                throw NetworkError.unknown(code: -1, error: error.localizedDescription)
//            }
//        }
//    }
//
//    // MARK: - Logging
//    private func logRequest(_ request: URLRequest) {
//        print("=== Request ===")
//        print("URL: \(request.url?.absoluteString ?? "Invalid URL")")
//        print("Method: \(request.httpMethod ?? "No Method")")
//        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
//        print("parameters: \(request.allHTTPHeaderFields ?? [:])")
//
//        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
//            print("Body: \(bodyString)")
//        }
//        print("===============")
//    }
//
//    private func logResponse(_ response: HTTPURLResponse, data: Data?) {
//        print("=== Response ===")
//        print("Status Code: \(response.statusCode)")
//        print("Headers: \(response.allHeaderFields)")
//        if let data = data, let dataString = String(data: data, encoding: .utf8) {
//            print("Body: \(dataString)")
//        }
//        print("================")
//    }
//}


//import Foundation
//import os.log
//protocol AsyncAwaitNetworkServiceProtocol {
//    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? //async/await
//}
//final class AsyncAwaitNetworkService: AsyncAwaitNetworkServiceProtocol {
//  
//    
//    static let shared = AsyncAwaitNetworkService()
//    private init() {}
//
//    private let logger = Logger(subsystem: "com.sehaty.network", category: "networking")
//    private let defaultTimeout: TimeInterval = 30.0
//    private let maxRetryCount = 2
//
////    func request<T: Decodable>(_ target: TargetType1, responseType: T.Type) async throws -> T {
//        func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? {
//
//        guard Helper.shared.isConnectedToNetwork() else {
//            throw NetworkError.noConnection
//        }
//
//        let url = target.baseURL.appendingPathComponent(target.path)
//        var request = try buildRequest(for: target, url: url)
//
//        var lastError: Error?
//
//        for attempt in 1...maxRetryCount {
//            logRequest(request, attempt: attempt)
//
//            do {
//                let startTime = Date()
//                let (data, response) = try await URLSession.shared.data(for: request)
//                let duration = Date().timeIntervalSince(startTime)
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw NetworkError.invalidJSON("Invalid response object")
//                }
//
//                logResponse(httpResponse, data: data, duration: duration)
//
//                guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
//                      contentType.contains("application/json") else {
//                    throw NetworkError.invalidJSON("Unexpected content type")
//                }
//
//                switch httpResponse.statusCode {
//                case 200..<300:
//                    return try decodeResponse(data, responseType)
//
//                case 401 where attempt == 1:
//                    // Placeholder for token refresh logic
//                    // if let newToken = try? await AuthManager.shared.refreshToken() {
//                    //     request.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
//                    //     continue
//                    // }
//                    throw NetworkError.unauthorized(code: httpResponse.statusCode, error: "Unauthorized")
//
//                case 400..<500:
//                    throw NetworkError.unknown(code: httpResponse.statusCode, error: "Client Error")
//
//                case 500..<600:
//                    throw NetworkError.serverError(code: httpResponse.statusCode, error: "Server Error")
//
//                default:
//                    throw NetworkError.unknown(code: httpResponse.statusCode, error: "Unhandled status code")
//                }
//
//            } catch let error as NetworkError {
//                throw error
//            } catch {
//                lastError = error
//                logger.warning("Attempt \(attempt) failed with error: \(error.localizedDescription)")
//                if attempt == maxRetryCount {
//                    throw NetworkError.unknown(code: -1, error: error.localizedDescription)
//                }
//            }
//        }
//
//        throw lastError ?? NetworkError.unknown(code: -1, error: "Unknown failure")
//    }
//
//    // MARK: - Build Request
//
//    private func buildRequest(for target: TargetType1, url: URL) throws -> URLRequest {
//        var request = URLRequest(url: url)
//        request.httpMethod = target.method.rawValue
//        request.timeoutInterval = target.timeoutInterval ?? defaultTimeout
//
//        // Headers
//        var headers = target.headers ?? [:]
//        if let token = Helper.shared.getUser()?.token {
//            headers["Authorization"] = "Bearer \(token)"
//        }
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//
//        // Parameters
//        if let parameters = target.parameters {
//            switch target.method {
//            case .get:
//                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
//                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//                    request.url = urlComponents.url
//                }
//            case .post, .put, .patch:
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            default:
//                break
//            }
//        }
//
//        return request
//    }
//
//    // MARK: - Decode
//
//    private func decodeResponse<T: Codable>(_ data: Data, _ type: T.Type) throws -> T {
//        if let wrapper = try? JSONDecoder().decode(BaseResponse<T>.self, from: data),
//           let result = wrapper.data {
//            return result
//        }
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//
//    // MARK: - Logging
//
//    private func logRequest(_ request: URLRequest, attempt: Int) {
//        #if DEBUG
//        print("=== Request Attempt \(attempt) ===")
//        print("URL: \(request.url?.absoluteString ?? "Invalid URL")")
//        print("Method: \(request.httpMethod ?? "No Method")")
//        let safeHeaders = request.allHTTPHeaderFields?.filter { $0.key.lowercased() != "authorization" }
//        print("Headers: \(safeHeaders ?? [:])")
//        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
//            print("Body: \(bodyString)")
//        }
//        print("=============================")
//        #endif
//    }
//
//    private func logResponse(_ response: HTTPURLResponse, data: Data?, duration: TimeInterval) {
//        #if DEBUG
//        print("=== Response ===")
//        print("Status Code: \(response.statusCode)")
//        print("Duration: \(duration)s")
//        print("Headers: \(response.allHeaderFields)")
//        if let data = data, let dataString = String(data: data, encoding: .utf8) {
//            print("Body: \(dataString.prefix(1000))...") // Limit output
//        }
//        print("================")
//        #endif
//    }
//}




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
        case .badURL(let errorMsg):
            return NSLocalizedString("Bad Url", comment: errorMsg)
        case .apiError(_, let errorMsg):
            return errorMsg
        case .invalidJSON(let errorMsg):
            return NSLocalizedString("00", comment: errorMsg)
        case .unauthorized(_, let errorMsg):
            return errorMsg
        case .badRequest(_, let errorMsg):
            return errorMsg
        case .serverError(_, let errorMsg):
            return errorMsg
        case .noResponse(let errorMsg):
            return errorMsg
        case .unableToParseData(let errorMsg):
            return errorMsg
        case .unknown(_, let errorMsg):
            return errorMsg
        case .expiredTokenMsg:
            return "login_expired"
        case .noConnection:
            return "no_connection"

        }
    }
}

// ----------------------------

protocol TargetType1 {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var timeoutInterval: TimeInterval? { get }  // Add this line

}
extension TargetType1 {
    var baseURL: URL {
        return URL(string: Constants.apiURL)!
    }
    // MARK: - Request URL
    var requestURL: URL {
        return baseURL.appendingPathComponent(path)
    }
    var headers: [String: String]? {
        var header = [String: String]()
        header["Content-Type"] = "application/json"
        header ["Accept"] = "multipart/form-data"
        if let token = Helper.shared.getUser()?.token {
        header["Authorization"] = "Bearer " + token
        }
        return header
    }

}

import Foundation
import os.log

protocol AsyncAwaitNetworkServiceProtocol {
    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T?
    func uploadMultipart<T: Codable>(_ target: TargetType1, parts: [MultipartFormDataPart], responseType: T.Type) async throws -> T?
}

final class AsyncAwaitNetworkService: AsyncAwaitNetworkServiceProtocol {

    static let shared = AsyncAwaitNetworkService()
    private init() {}

    private let logger = Logger(subsystem: "com.sehaty.network", category: "networking")
    private let defaultTimeout: TimeInterval = 30.0
    private let maxRetryCount = 2

    func request<T: Codable>(_ target: TargetType1, responseType: T.Type) async throws -> T? {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }

        let url = target.baseURL.appendingPathComponent(target.path)
        let request = try buildRequest(for: target, url: url)

        var lastError: Error?

        for attempt in 1...maxRetryCount {
            logRequest(request, attempt: attempt)

            do {
                let start = Date()
                let (data, response) = try await URLSession.shared.data(for: request)
                let duration = Date().timeIntervalSince(start)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidJSON("Invalid response object")
                }

                logResponse(httpResponse, data: data, duration: duration)

                guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
                    throw NetworkError.invalidJSON("Missing Content-Type header")
                }

                guard contentType.contains("application/json") else {
                    throw NetworkError.invalidJSON("Unexpected Content-Type: \(contentType)")
                }


                switch httpResponse.statusCode {
                case 200..<300:
                    return try decodeResponse(data, responseType)
                case 401:
                    // Handle token refresh in future
                    throw NetworkError.unauthorized(code: httpResponse.statusCode, error: "Unauthorized")
                case 400..<500:
//                        throw NetworkError.unknown(code: httpResponse.statusCode, error: "client error")
                    let serverMessage: String

                       do {
                           let errorResponse = try JSONDecoder().decode(ServerErrorResponse.self, from: data)
                           serverMessage = errorResponse.message
                       } catch {
                           serverMessage = String(data: data, encoding: .utf8) ?? "Unknown client error"
                       }

                       throw NetworkError.unknown(code: httpResponse.statusCode, error: serverMessage)
                    
                case 500..<600:
                    throw NetworkError.serverError(code: httpResponse.statusCode, error: "Server error")
                default:
                    throw NetworkError.unknown(code: httpResponse.statusCode, error: "Unhandled status code")
                }
       

            } catch let error as NetworkError {
                throw error
            } catch {
                lastError = error
                logger.warning("Attempt \(attempt) failed: \(error.localizedDescription)")
                if attempt == maxRetryCount {
                    throw NetworkError.unknown(code: -1, error: error.localizedDescription)
                }
            }
        }

        throw lastError ?? NetworkError.unknown(code: -1, error: "Unknown failure")
    }

    // MARK: - Request Building
    private func buildRequest(for target: TargetType1, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.timeoutInterval = target.timeoutInterval ?? defaultTimeout

        // Headers
        var headers = target.headers ?? [:]
        if let token = Helper.shared.getUser()?.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Parameters
        if let parameters = target.parameters {
            switch target.method {
            case .get:
                if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    request.url = components.url
                }
            case .post, .put, .patch:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            default:
                break
            }
        }

        return request
    }

    // MARK: - Decoding
    private func decodeResponse<T: Codable>(_ data: Data, _ type: T.Type) throws -> T? {
        // Try BaseResponse wrapper
        if let wrapper = try? JSONDecoder().decode(BaseResponse<T>.self, from: data),
           let result = wrapper.data {
            return result
        }

        // Fallback to direct decoding
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Logging
    private func logRequest(_ request: URLRequest, attempt: Int) {
        #if DEBUG
        print("=== Request [Attempt \(attempt)] ===")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        let safeHeaders = request.allHTTPHeaderFields?.filter { $0.key.lowercased() != "authorization" }
        print("Headers: \(safeHeaders ?? [:])")
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("=========================")
        #endif
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data?, duration: TimeInterval) {
        #if DEBUG
        print("=== Response ===")
        print("Status Code: \(response.statusCode)")
        print("Duration: \(String(format: "%.2f", duration))s")
        print("Headers: \(response.allHeaderFields)")
        if let data = data, let body = String(data: data, encoding: .utf8) {
            print("Body: \(body.prefix(1000))...") // Truncate long body
        }
        print("================")
        #endif
    }
}



extension AsyncAwaitNetworkService {
    func uploadMultipart<T: Codable>(
        _ target: TargetType1,
        parts: [MultipartFormDataPart],
        responseType: T.Type
    ) async throws -> T? {
        guard Helper.shared.isConnectedToNetwork() else {
            throw NetworkError.noConnection
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let url = target.baseURL.appendingPathComponent(target.path)
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.timeoutInterval = target.timeoutInterval ?? defaultTimeout

        // Set headers
        var headers = target.headers ?? [:]
//        var headers : [String: String] = [:]
        if let token = Helper.shared.getUser()?.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        headers["accept"] = "text/plain"

        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Construct body
        request.httpBody = createMultipartBody(parts: parts, boundary: boundary)

        logRequest(request, attempt: 1)
        if let body = request.httpBody {
            let preview = String(decoding: body, as: UTF8.self)
            print("🔍 Multipart Body Preview:\n\(preview.prefix(1000))")
        }
        
        let start = Date()
        let (data, response) = try await URLSession.shared.data(for: request)
        let duration = Date().timeIntervalSince(start)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidJSON("Invalid response object")
        }

        logResponse(httpResponse, data: data, duration: duration)

        switch httpResponse.statusCode{
        case 200..<300:
//            // ✅ Safe decode if data is non-empty
//                if data.isEmpty  {
//                    return nil
//                } else {
                    return try decodeResponse(data, responseType)
//                }
        case 401:
            // Handle token refresh in future
            throw NetworkError.unauthorized(code: httpResponse.statusCode, error: "Unauthorized")
        case 400..<500:
//                        throw NetworkError.unknown(code: httpResponse.statusCode, error: "client error")
            let serverMessage: String
               do {
                   let errorResponse = try JSONDecoder().decode(ServerErrorResponse.self, from: data)
                   serverMessage = errorResponse.message
               } catch {
                   serverMessage = String(data: data, encoding: .utf8) ?? "Unknown client error"
               }

               throw NetworkError.unknown(code: httpResponse.statusCode, error: serverMessage)
            
        case 500..<600:
            throw NetworkError.serverError(code: httpResponse.statusCode, error: "Server error")
        default:
            throw NetworkError.unknown(code: httpResponse.statusCode, error: "Unhandled status code")
        }
        
//        switch httpResponse.statusCode {
//        case 200..<300:
//            return try decodeResponse(data, responseType)
//        case 400..<500:
//            let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data)
//            throw NetworkError.unknown(code: httpResponse.statusCode, error: errorResponse?.message ?? "Client error")
//        case 500..<600:
//            throw NetworkError.serverError(code: httpResponse.statusCode, error: "Server error")
//        default:
//            throw NetworkError.unknown(code: httpResponse.statusCode, error: "Unhandled status code")
//        }
    }
    
    
    private func createMultipartBody(parts: [MultipartFormDataPart], boundary: String) -> Data {
        var body = Data()

        for part in parts {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)

            // File part (voice, image, etc.)
            if let filename = part.filename,
               let mimeType = part.mimeType,
               let data = part.data {
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }

            // Text field
            else if let data = part.data {
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
