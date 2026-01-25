////
////  ChatsViewModel.swift
////  Sehaty
////
////  Created by mohamed hammam on 09/06/2025.
////
//
//import Foundation
////import FirebaseFirestore
////import FirebaseStorage
////import AVFoundation
//
//class ChatsViewModel:ObservableObject {
//    static let shared = ChatsViewModel()
//    // Injected service
//    private let networkService: AsyncAwaitNetworkServiceProtocol
//    private var loadTask: Task<Void,Never>? = nil
//
//    var CustomerPackageId : Int?
//
//    @Published var inputText: String = ""
//    @Published var recordingURL: URL? = nil
//
//    // Published properties
//    @Published var ChatMessages: [ChatsMessageM]?
////    = [
////        ChatsMessageM(
////            customerPackageID: 1,
////            comment: "Hello doctor, I have a question about my treatment.",
////            sendByCustomer: true,
////            sendByDoctor: false,
////            voicePath: nil,
////            doctorID: 101,
////            creationDate: "2025-09-17T10:15:00Z",
////            customerName: "Mohamed",
////            doctorName: "Dr. Ahmed",
////            customerImage: nil,
////            doctorImage: nil
////        ),
////        ChatsMessageM(
////            customerPackageID: 1,
////            comment: "Sure, please go ahead.",
////            sendByCustomer: false,
////            sendByDoctor: true,
////            voicePath: nil,
////            doctorID: 101,
////            creationDate: "2025-09-17T10:16:00Z",
////            customerName: "Mohamed",
////            doctorName: "Dr. Ahmed",
////            customerImage: nil,
////            doctorImage: nil
////        ),
////        ChatsMessageM(
////            customerPackageID: 1,
////            comment: "Is it okay to take the medicine after eating?",
////            sendByCustomer: true,
////            sendByDoctor: false,
////            voicePath: nil,
////            doctorID: 101,
////            creationDate: "2025-09-17T10:17:00Z",
////            customerName: "Mohamed",
////            doctorName: "Dr. Ahmed",
////            customerImage: nil,
////            doctorImage: nil
////        ),
////        ChatsMessageM(
////            customerPackageID: 1,
////            comment: "Yes, that’s fine. Just make sure to take it with water.",
////            sendByCustomer: false,
////            sendByDoctor: true,
////            voicePath: nil,
////            doctorID: 101,
////            creationDate: "2025-09-17T10:18:00Z",
////            customerName: "Mohamed",
////            doctorName: "Dr. Ahmed",
////            customerImage: nil,
////            doctorImage: nil
////        )
////    ]
//
//    @Published var CreatedMessage: ChatsMessageM?
//
//    @Published var isLoading:Bool? = false
//    @Published var errorMessage: String? = nil
//
//    // Init with DI
//    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
//        self.networkService = networkService
//    }
//}
//
////MARK: -- Functions --
//extension ChatsViewModel{
//
//    @MainActor
//    func getMessages() async {
//        // Cancel any in-flight unified load to prevent overlap
//        loadTask?.cancel()
//        loadTask = Task { [weak self] in
//            guard let self else { return }
//            if self.isLoading == true { return }
//
//            isLoading = true
//            defer { isLoading = false }
//            guard let CustomerPackageId = CustomerPackageId else {
//                //            // Handle missings
//                //            self.errorMessage = "check inputs"
//                //            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//                return
//            }
//            let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
//
//            let target = SubscriptionServices.GetMessage(parameters: parametersarr)
//            do {
//                self.errorMessage = nil // Clear previous errors
//                let response = try await networkService.request(
//                    target,
//                    responseType: [ChatsMessageM].self
//                )
//                self.ChatMessages = response?.compactMap({($0.messageText.count > 0 || $0.voicePath?.count ?? 0 > 0) ? $0 : nil})
//            } catch {
//                self.errorMessage = error.localizedDescription
//            }
//        }
//        await loadTask?.value
//    }
//
//    @MainActor
//    func createCustomerMessage() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let CustomerPackageId = CustomerPackageId else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
////        var parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
//        var parts: [MultipartFormDataPart] = [
//            .init(name: "CustomerPackageId", value: "\(CustomerPackageId)")
////            ,.init(name: "CustomerName", value: customerName)
////            ,.init(name: "SessionType", value: sessionType)
//        ]
//
//        if inputText.count > 0 {
////            parametersarr["Comment"] = inputText
//            parts.append(.init(name: "Comment", value: inputText))
//        }
//
//        if let recordingURL = recordingURL
//            ,let fileData = try? Data(contentsOf: recordingURL) {
////                        parametersarr["VoicePath"] = fileData
//            print("recordingURL: \(recordingURL)")
//            print("fileData: \(fileData)")
//
//             parts.append(
//                 .init(name: "VoicePath", filename: "voice.mp3", mimeType: "audio/m4a", data: fileData)
//             )
//            }
//
//        print("parts: \(parts)")
//
////        if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
////            parts.append(.init(name: "Comment", value: inputText))
////        }
//
////        if let url = recordingURL,
////           let fileData = try? Data(contentsOf: url) {
////            parts.append(
////                .init(name: "VoicePath", filename: "voice.m4a", mimeType: "audio/m4a", data: fileData)
////            )
////        }
//
//        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
//        do {
//            self.errorMessage = nil // Clear previous errors
////            let response = try await networkService.request(
////                target,
////                responseType: [ChatsMessageM].self
////            )
//           let response = try await networkService.uploadMultipart(target
//                                                         , parts: parts
//                                                         , responseType: ChatsMessageM.self)
//            if let newMessage = response{
//                self.ChatMessages?.append(newMessage)
//            }
//            self.inputText = ""
//            self.recordingURL = nil
////            await getMessages()
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//
//}
//
//extension ChatsViewModel {
//
//    @MainActor
//    func refresh() async {
//        //        skipCount = 0
//        await getMessages()
//    }
//
//}





//
//  ChatsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
//import FirebaseStorage
//import AVFoundation

class ChatsViewModel:ObservableObject {
    static let shared = ChatsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil

    private var firestoreListener: ListenerRegistration? = nil

    var CustomerPackageId : Int?

    @Published var inputText: String = ""
    @Published var recordingURL: URL? = nil

    // Published properties
    @Published var ChatMessages: [ChatsMessageM]?
//    = [
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Hello doctor, I have a question about my treatment.",
//            sendByCustomer: true,
//            sendByDoctor: false,
//            voicePath: nil,
//            doctorID: 101,
//            creationDate: "2025-09-17T10:15:00Z",
//            customerName: "Mohamed",
//            doctorName: "Dr. Ahmed",
//            customerImage: nil,
//            doctorImage: nil
//        ),
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Sure, please go ahead.",
//            sendByCustomer: false,
//            sendByDoctor: true,
//            voicePath: nil,
//            doctorID: 101,
//            creationDate: "2025-09-17T10:16:00Z",
//            customerName: "Mohamed",
//            doctorName: "Dr. Ahmed",
//            customerImage: nil,
//            doctorImage: nil
//        ),
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Is it okay to take the medicine after eating?",
//            sendByCustomer: true,
//            sendByDoctor: false,
//            voicePath: nil,
//            doctorID: 101,
//            creationDate: "2025-09-17T10:17:00Z",
//            customerName: "Mohamed",
//            doctorName: "Dr. Ahmed",
//            customerImage: nil,
//            doctorImage: nil
//        ),
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Yes, that’s fine. Just make sure to take it with water.",
//            sendByCustomer: false,
//            sendByDoctor: true,
//            voicePath: nil,
//            doctorID: 101,
//            creationDate: "2025-09-17T10:18:00Z",
//            customerName: "Mohamed",
//            doctorName: "Dr. Ahmed",
//            customerImage: nil,
//            doctorImage: nil
//        )
//    ]

    @Published var CreatedMessage: ChatsMessageM?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil

    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
        // Start Firestore listening if CustomerPackageId is already set
        if CustomerPackageId != nil {
            startListeningForMessages()
        }
    }
    
    // Call this after setting CustomerPackageId from outside as well
    func startListeningForMessages() {
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] startListeningForMessages: CustomerPackageId is nil, cannot listen.")
            return
        }
        print("[ChatsViewModel] startListeningForMessages: Starting listener for CustomerPackageId: \(customerPackageId)")
        firestoreListener?.remove()
        let db = Firestore.firestore()
        firestoreListener = db.collection("chats")
            .document("\(customerPackageId)")
            .collection("messages")
            .order(by: "creationDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("[ChatsViewModel] Firestore listener error: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("[ChatsViewModel] Firestore listener: No documents found.")
                    return
                }
                let messages = documents.compactMap { doc -> ChatsMessageM? in
                    let data = doc.data()
                    if let message = ChatsMessageM(fromFirestoreData: data) {
                        return message
                    } else {
                        print("[ChatsViewModel] Firestore listener: Failed to parse message from document \(doc.documentID)")
                        return nil
                    }
                }
                DispatchQueue.main.async {
                    self.ChatMessages = messages
                    // Debug print count
                    print("[ChatsViewModel] Firestore listener: Updated ChatMessages with \(messages.count) messages.")
                }
            }
    }
    
    func stopListening() {
        print("[ChatsViewModel] stopListening: Removing Firestore listener if any.")
        firestoreListener?.remove()
        firestoreListener = nil
    }
    
    private func sendMessageToFirestore(_ message: ChatsMessageM) {
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] sendMessageToFirestore: CustomerPackageId is nil, cannot send.")
            return
        }
        let db = Firestore.firestore()
        var data: [String: Any] = [
            "customerPackageID": message.customerPackageID ?? 0,
            "comment": message.comment ?? "",
            "sendByCustomer": message.sendByCustomer ?? false,
            "sendByDoctor": message.sendByDoctor ?? false,
            "doctorID": message.doctorID ?? 0,
            "creationDate": message.creationDate ?? "",
            "customerName": message.customerName ?? "",
            "doctorName": message.doctorName ?? ""
        ]
        if let voicePath = message.voicePath {
            data["voicePath"] = voicePath
        }
        // Note: Not including images in this Firestore message
        
        db.collection("chats")
            .document("\(customerPackageId)")
            .collection("messages")
            .addDocument(data: data) { error in
                if let error = error {
                    print("[ChatsViewModel] sendMessageToFirestore: Error sending message to Firestore: \(error.localizedDescription)")
                } else {
                    print("[ChatsViewModel] sendMessageToFirestore: Successfully sent message to Firestore.")
                }
            }
    }
}

//MARK: -- Functions --
extension ChatsViewModel{

    @MainActor
    func getMessages() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            isLoading = true
            defer { isLoading = false }
            guard let CustomerPackageId = CustomerPackageId else {
                //            // Handle missings
                //            self.errorMessage = "check inputs"
                //            //            throw NetworkError.unknown(code: 0, error: "check inputs")
                return
            }
            let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]

            let target = SubscriptionServices.GetMessage(parameters: parametersarr)
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [ChatsMessageM].self
                )
                self.ChatMessages = response?.compactMap({($0.messageText.count > 0 || $0.voicePath?.count ?? 0 > 0) ? $0 : nil})
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }

    @MainActor
    func createCustomerMessage() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerPackageId = CustomerPackageId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
//        var parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        var parts: [MultipartFormDataPart] = [
            .init(name: "CustomerPackageId", value: "\(CustomerPackageId)")
//            ,.init(name: "CustomerName", value: customerName)
//            ,.init(name: "SessionType", value: sessionType)
        ]

        if inputText.count > 0 {
//            parametersarr["Comment"] = inputText
            parts.append(.init(name: "Comment", value: inputText))
        }

        if let recordingURL = recordingURL
            ,let fileData = try? Data(contentsOf: recordingURL) {
//                        parametersarr["VoicePath"] = fileData
            print("recordingURL: \(recordingURL)")
            print("fileData: \(fileData)")

             parts.append(
                 .init(name: "VoicePath", filename: "voice.mp3", mimeType: "audio/m4a", data: fileData)
             )
            }

        print("parts: \(parts)")

//        if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
//            parts.append(.init(name: "Comment", value: inputText))
//        }

//        if let url = recordingURL,
//           let fileData = try? Data(contentsOf: url) {
//            parts.append(
//                .init(name: "VoicePath", filename: "voice.m4a", mimeType: "audio/m4a", data: fileData)
//            )
//        }

        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
        do {
            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [ChatsMessageM].self
//            )
           let response = try await networkService.uploadMultipart(target
                                                         , parts: parts
                                                         , responseType: ChatsMessageM.self)
            if let newMessage = response{
                self.ChatMessages?.append(newMessage)
                sendMessageToFirestore(newMessage)
            }
            self.inputText = ""
            self.recordingURL = nil
//            await getMessages()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

}

extension ChatsViewModel {

    @MainActor
    func refresh() async {
        //        skipCount = 0
        await getMessages()
    }

}

// Minimal failable initializer for ChatsMessageM from Firestore data
extension ChatsMessageM {
    init?(fromFirestoreData data: [String: Any]) {
        // Map fields safely
        self.customerPackageID = data["customerPackageID"] as? Int
        self.comment = data["comment"] as? String
        self.sendByCustomer = data["sendByCustomer"] as? Bool
        self.sendByDoctor = data["sendByDoctor"] as? Bool
        self.voicePath = data["voicePath"] as? String
        self.doctorID = data["doctorID"] as? Int
        self.creationDate = data["creationDate"] as? String
        self.customerName = data["customerName"] as? String
        self.doctorName = data["doctorName"] as? String
        self.customerImage = nil
        self.doctorImage = nil
        
        // Validate at least one required field, e.g. creationDate and comment or voicePath
        if self.creationDate == nil {
            return nil
        }
        // If comment and voicePath both are nil or empty, ignore
        if (self.comment?.isEmpty ?? true) && (self.voicePath?.isEmpty ?? true) {
            return nil
        }
    }
}
