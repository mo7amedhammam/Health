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





////
////  ChatsViewModel.swift
////  Sehaty
////
////  Created by mohamed hammam on 09/06/2025.
////
//
import Foundation
import FirebaseFirestore
import FirebaseCore

class ChatsViewModel: ObservableObject {
    static let shared = ChatsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void, Never>? = nil

    private var firestoreListener: ListenerRegistration? = nil

    var CustomerPackageId: Int? {
        didSet {
            if CustomerPackageId != nil {
                startListeningForMessages()
            } else {
                stopListening()
            }
        }
    }

    @Published var inputText: String = ""
    @Published var recordingURL: URL? = nil

    // Published properties
    @Published var ChatMessages: [ChatsMessageM]?

    @Published var CreatedMessage: ChatsMessageM?

    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil

    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    func configure(customerPackageId: Int) {
        self.CustomerPackageId = customerPackageId
    }
    
    func startListeningForMessages() {
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] startListeningForMessages: CustomerPackageId is nil, cannot listen.")
            return
        }
        print("[ChatsViewModel] startListeningForMessages: Starting listener for CustomerPackageId: \(customerPackageId)")
        // Remove any existing listener first
        firestoreListener?.remove()
        firestoreListener = nil

        let db: Firestore = Firestore.firestore()
        let chatsRef: CollectionReference = db.collection("chats")
        let chatDocRef: DocumentReference = chatsRef.document("\(customerPackageId)")
        let messagesRef: CollectionReference = chatDocRef.collection("messages")
        let query: Query = messagesRef.order(by: "serverTimestamp", descending: false)

        firestoreListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("[ChatsViewModel] Firestore listener error: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("[ChatsViewModel] Firestore listener: No documents found.")
                return
            }

            // Parse messages explicitly
            var parsedMessages: [ChatsMessageM] = []
            parsedMessages.reserveCapacity(documents.count)
            for doc in documents {
                let data = doc.data()
                if let message = ChatsMessageM(fromFirestoreData: data) {
                    parsedMessages.append(message)
                } else {
                    print("[ChatsViewModel] Firestore listener: Failed to parse message from document \(doc.documentID)")
                }
            }

            DispatchQueue.main.async {
                let existing = self.ChatMessages ?? []
                let combined = existing + parsedMessages

                // Build a dictionary keyed by a stable string to remove duplicates
                var seen: [String: ChatsMessageM] = [:]
                seen.reserveCapacity(combined.count)

                for msg in combined {
                    let keyCreation = msg.creationDate ?? ""
                    let keyComment = msg.comment ?? ""
                    let keyVoice = msg.voicePath ?? ""
                    let key = [keyCreation, keyComment, keyVoice].joined(separator: "|§|")
                    if seen[key] == nil {
                        seen[key] = msg
                    }
                }

                let unique = Array(seen.values)
                    .sorted { ($0.creationDate ?? "") < ($1.creationDate ?? "") }

                self.ChatMessages = unique
                print("[ChatsViewModel] Firestore listener: Updated ChatMessages with \(unique.count) unique messages.")
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
            "doctorName": message.doctorName ?? "",
            "serverTimestamp": FieldValue.serverTimestamp()
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
extension ChatsViewModel {

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
                return
            }
            let parametersarr: [String: Any] = ["CustomerPackageId": CustomerPackageId]

            let target = SubscriptionServices.GetMessage(parameters: parametersarr)
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [ChatsMessageM].self
                )
                self.ChatMessages = response?.compactMap({($0.messageText.count > 0 || $0.voicePath?.count ?? 0 > 0) ? $0 : nil})
                self.startListeningForMessages()
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
            return
        }
        var parts: [MultipartFormDataPart] = [
            .init(name: "CustomerPackageId", value: "\(CustomerPackageId)")
        ]

        if inputText.count > 0 {
            parts.append(.init(name: "Comment", value: inputText))
        }

        if let recordingURL = recordingURL,
           let fileData = try? Data(contentsOf: recordingURL) {
            print("recordingURL: \(recordingURL)")
            print("fileData: \(fileData)")

            parts.append(
                .init(name: "VoicePath", filename: "voice.mp3", mimeType: "audio/m4a", data: fileData)
            )
        }

        print("parts: \(parts)")

        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.uploadMultipart(target, parts: parts, responseType: ChatsMessageM.self)
            if let newMessage = response {
                self.ChatMessages?.append(newMessage)
                sendMessageToFirestore(newMessage)
            }
            self.inputText = ""
            self.recordingURL = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

extension ChatsViewModel {

    @MainActor
    func refresh() async {
        await getMessages()
    }
}

// Minimal failable initializer for ChatsMessageM from Firestore data
extension ChatsMessageM {
    init?(fromFirestoreData data: [String: Any]) {
        func intFrom(_ any: Any?) -> Int? {
            if let i = any as? Int { return i }
            if let d = any as? Double { return Int(d) }
            if let s = any as? String { return Int(s) }
            return nil
        }
        self.customerPackageID = intFrom(data["customerPackageID"])
        self.comment = data["comment"] as? String
        self.sendByCustomer = data["sendByCustomer"] as? Bool
        self.sendByDoctor = data["sendByDoctor"] as? Bool
        self.voicePath = data["voicePath"] as? String
        self.doctorID = intFrom(data["doctorID"])
        self.creationDate = data["creationDate"] as? String
        self.customerName = data["customerName"] as? String
        self.doctorName = data["doctorName"] as? String
        self.customerImage = nil
        self.doctorImage = nil
        
        // If both comment and voicePath are empty or nil, discard
        if (self.comment?.isEmpty ?? true) && (self.voicePath?.isEmpty ?? true) {
            return nil
        }
    }
}

