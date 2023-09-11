//
//  BaseRequest.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//
import Foundation
import UIKit
import Alamofire
import Combine

func buildparameter(paramaters:parameterType)->([String:Any],ParameterEncoding){
    switch paramaters{
    case .plainRequest:
        return ([:],URLEncoding.default)
    case .parameterRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)
    case .BodyparameterRequest(Parameters: let Parameters, Encoding: let Encoding):
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
    
    static func callApi<T: TargetType, M: Codable>(
        _ target: T,
        _ modelType: M.Type,
        completion: @escaping (Result<M, NetworkError>) -> Void
    ) {
        guard Helper.isConnectedToNetwork() else{
            completion(.failure(NetworkError.noConnection))
            return
        }
        
        let parameters = buildparameter(paramaters: target.parameter)
        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
        print(target.requestURL)
        print(target.method)
        print(parameters)
        print(headers ?? [:])
        
        AF.request(target.requestURL, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: headers)
            .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
                if response.response?.statusCode == 401 {
                    completion(.failure(.unauthorized(code: response.response?.statusCode ?? 0, error: NetworkError.expiredTokenMsg.errorDescription ?? "")))
                } else {
                    switch response.result {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(.unknown(code: 0, error: error.localizedDescription)))
                    }
                }
            }
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
     func uploadApi<T: TargetType, M: Codable>(
        _ target: T,
        _ Model: M.Type,
        completion: @escaping (Result<M, NetworkError>) -> Void
    ) {
        guard Helper.isConnectedToNetwork() else{
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
                    if let data = tempImg.jpegData(compressionQuality: 0.8), (tempImg.size.width ) > 0 {
                        // Be careful and put the file name in withName parameter
                        multipartFormData.append(data, withName: key , fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
                }
                if let tempStr = value as? String {
                    multipartFormData.append(tempStr.data(using: .utf8)!, withName: key)
                }
                if let tempInt = value as? Int {
                    multipartFormData.append("\(tempInt)".data(using: .utf8)!, withName: key)
                }
                if let tempArr = value as? NSArray {
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

    static func downloadFile(
        from sourceURL: URL,
        to destinationURL: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let destination: DownloadRequest.Destination = { _, _ in
               return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
           }
        AF.download(sourceURL, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted * 100)%")
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
            return " يجب تسجيل دخول من جديد"
        case .noConnection:
            return "لا يوجد إتصال بالإنترنت"

        }
    }
}

struct BGDecoder {

    static func decode<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

}
