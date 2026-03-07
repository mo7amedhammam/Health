import Foundation
import FirebaseMessaging

enum KeychainKeys {
    static let userPhone = "userPhone"
    static let userPassword = "password"
}

protocol LoginViewModelProtocol {
    var appCountryId: Int? { get set }
    var mobile: String? { get set }
    var password: String? { get set }
    var usermodel: LoginM? { get }

    func login(completion: @escaping (Result<Void, Error>) -> Void)
    func registerFirebaseDeviceToken(completion: @escaping (Result<Void, Error>) -> Void)
//    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    var appCountryId: Int?
    var mobile: String?
    var password: String?
    var usermodel: LoginM?
    private let networkService: NetworkServiceProtocol
//    private let deleteTokenUseCase: DeleteFirebaseTokenUseCaseProtocol

    init(networkService: NetworkServiceProtocol = NetworkService1.shared) {
        self.networkService = networkService
    }

    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let mobile = mobile, let password = password else {
            completion(.failure(LoginError.invalidCredentials))
            return
        }

        let parameters: [String: Any] = ["mobile": mobile, "password": password]
        let target = NewAuthontications.Login(parameters: parameters)

        networkService.request(target, responseType: BaseResponse<LoginM>.self) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if response.messageCode == 200 {
                    self.usermodel = response.data
                    completion(.success(()))
                    self.registerFirebaseDeviceToken { _ in }
                    KeychainHelper.save(mobile, forKey: KeychainKeys.userPhone)
                    KeychainHelper.save(password, forKey: KeychainKeys.userPassword)
                } else {
                    let errorMessage = response.message ?? ""
                    completion(.failure(NetworkError.unknown(code: response.messageCode ?? 0, error: errorMessage)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func registerFirebaseDeviceToken(completion: @escaping (Result<Void, Error>) -> Void) {
        getDeviceToken { [weak self] token in
            guard let self = self else { return }

            let parameters: [String: Any] = {
                switch Helper.shared.getSelectedUserType() {
                case .Customer, .none:
                    return ["customerDeviceToken": token]
                case .Doctor:
                    return ["firebaseDeviceToken": token]
                }
            }()

            let target = NewAuthontications.SendFireBaseDeviceToken(parameters: parameters)

            self.networkService.request(target, responseType: BaseResponse<MFirebase>.self) { result in
                switch result {
                case .success(let response):
                    if response.messageCode == 200 {
                        completion(.success(()))
                    } else {
                        completion(.failure(LoginError.serverError(message: response.message ?? "Unknown error")))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getDeviceToken(completion: @escaping (String) -> Void) {
        if let token = Messaging.messaging().fcmToken {
            completion(token)
        } else {
            completion(Helper.shared.getFirebaseToken())
        }
    }

//    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
//        deleteTokenUseCase.execute(completion: completion)
//    }
}

enum LoginError: Error {
    case invalidCredentials
    case serverError(message: String)
}


protocol DeleteFirebaseTokenUseCaseProtocol {
    func execute() async throws
}

final class DeleteFirebaseTokenUseCase: DeleteFirebaseTokenUseCaseProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService1.shared) {
        self.networkService = networkService
    }

    func execute() async throws {

        let parameters: [String: Any] = [:]
        let target = NewAuthontications.DeleteFireBaseDeviceToken(parameters: parameters)

        let response: BaseResponse<MFirebase> = try await withCheckedThrowingContinuation { continuation in
            self.networkService.request(target, responseType: BaseResponse<MFirebase>.self) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        guard response.messageCode == 200 else {
            throw NetworkError.serverError(code: response.messageCode ?? 400, error: response.message ?? "Unknown error")
        }

    }
}
