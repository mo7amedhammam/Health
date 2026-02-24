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
//import Foundation
//import FirebaseFirestore
//import FirebaseCore
//
//class ChatsViewModel: ObservableObject {
//    static let shared = ChatsViewModel()
//    // Injected service
//    private let networkService: AsyncAwaitNetworkServiceProtocol
//    private var loadTask: Task<Void, Never>? = nil
//
//    private var firestoreListener: ListenerRegistration? = nil
//
//    // 🔑 Flag to ignore initial Firestore snapshot
//    private var didInitialFirestoreLoad = false{
//        didSet{
//            if didInitialFirestoreLoad {
//                startListeningForMessages()
//            }
//        }
//    }
//    
//    var CustomerPackageId: Int? {
//        didSet {
//            if CustomerPackageId != nil {
////                startListeningForMessages()
//            } else {
//                stopListening()
//            }
//        }
//    }
//
//    @Published var inputText: String = ""
//    @Published var recordingURL: URL? = nil
//
//    // Published properties
//    @Published var ChatMessages: ChatsMessageM?
//
//    @Published var CreatedMessage: ChatsMessageM?
//
//    @Published var isLoading: Bool? = false
//    @Published var errorMessage: String? = nil
//
//    // Init with DI
//    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
//        self.networkService = networkService
//    }
//    
//    func configure(customerPackageId: Int) {
//        self.CustomerPackageId = customerPackageId
//    }
//    
//    
////    func startListeningForMessages() {
////
////        guard let customerPackageId = CustomerPackageId else { return }
////
////        firestoreListener?.remove()
////        firestoreListener = nil
////        didInitialFirestoreLoad = false
////
////        let db = Firestore.firestore()
////        let query = db
////            .collection("chats")
////            .document("\(customerPackageId)")
////            .collection("messages")
////            .order(by: "serverTimestamp", descending: false)
////
////        firestoreListener = query.addSnapshotListener { [weak self] snapshot, error in
////            guard let self = self, let snapshot = snapshot else { return }
////
////            DispatchQueue.main.async {
////
////                // ❌ Ignore first snapshot (initial load)
////                if self.didInitialFirestoreLoad == false {
////                    self.didInitialFirestoreLoad = true
////                    return
////                }
////
////                var didReceiveIncomingMessage = false
////
////                for change in snapshot.documentChanges {
////
////                    guard change.type == .added else { continue }
////
////                    let data = change.document.data()
////
////                    guard let message = ChatsMessageItemM(fromFirestoreData: data) else { continue }
////
////                    let alreadyExists = self.ChatMessages?.MessagesList?.contains(where: {
////                        $0.creationDate == message.creationDate &&
////                        $0.comment == message.comment &&
////                        $0.voicePath == message.voicePath
////                    }) ?? false
////
////                    if alreadyExists { continue }
////
////                    self.ChatMessages?.MessagesList?.append(message)
////
////                    // 🔔 Incoming message (not from me)
////                    if !(message.isFromMe) {
////                        didReceiveIncomingMessage = true
////                    }
////                }
////
////                self.ChatMessages?.MessagesList?.sort {
////                    ($0.creationDate ?? "") < ($1.creationDate ?? "")
////                }
////
////                if didReceiveIncomingMessage {
////                    SoundPlayer.shared.playIncoming()
////                }
////            }
////        }
////    }
//    
//    
//    
//    func startListeningForMessages() {
//        guard let customerPackageId = CustomerPackageId else {
//            print("[ChatsViewModel] startListeningForMessages: CustomerPackageId is nil, cannot listen.")
//            return
//        }
//        print("[ChatsViewModel] startListeningForMessages: Starting listener for CustomerPackageId: \(customerPackageId)")
//        // Remove any existing listener first
//        firestoreListener?.remove()
//        firestoreListener = nil
//
//        let db: Firestore = Firestore.firestore()
//        let chatsRef: CollectionReference = db.collection("chats")
//        let chatDocRef: DocumentReference = chatsRef.document("\(customerPackageId)")
//        let messagesRef: CollectionReference = chatDocRef.collection("messages")
//        let query: Query = messagesRef.order(by: "serverTimestamp", descending: false)
//
//        firestoreListener = query.addSnapshotListener { [weak self] snapshot, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("[ChatsViewModel] Firestore listener error: \(error.localizedDescription)")
//                return
//            }
//            guard let documents = snapshot?.documents else {
//                print("[ChatsViewModel] Firestore listener: No documents found.")
//                return
//            }
//
//            // Parse messages explicitly
//            var parsedMessages: [ChatsMessageItemM] = []
//            parsedMessages.reserveCapacity(documents.count)
//            for doc in documents {
//                let data = doc.data()
//                if let message = ChatsMessageItemM(fromFirestoreData: data) {
//                    parsedMessages.append(message)
//                } else {
//                    print("[ChatsViewModel] Firestore listener: Failed to parse message from document \(doc.documentID)")
//                }
//            }
//
//            DispatchQueue.main.async {
//                let existing = self.ChatMessages?.MessagesList ?? []
//                let combined = existing + parsedMessages
//
//                // Build a dictionary keyed by a stable string to remove duplicates
//                var seen: [String: ChatsMessageItemM] = [:]
//                seen.reserveCapacity(combined.count)
//
//                for msg in combined {
//                    let keyCreation = msg.creationDate ?? ""
//                    let keyComment = msg.comment ?? ""
//                    let keyVoice = msg.voicePath ?? ""
//                    let key = [keyCreation, keyComment, keyVoice].joined(separator: "|§|")
//                    if seen[key] == nil {
//                        seen[key] = msg
//                    }
//                }
//
//                let unique = Array(seen.values)
//                    .sorted { ($0.creationDate ?? "") < ($1.creationDate ?? "") }
//
//                // Detect newly added messages compared to existing before updating
//                let existingKeys: Set<String> = Set(existing.map { [($0.creationDate ?? ""), ($0.comment ?? ""), ($0.voicePath ?? "")].joined(separator: "|§|") })
//                let newMessages = unique.filter { msg in
//                    let key = [ (msg.creationDate ?? ""), (msg.comment ?? ""), (msg.voicePath ?? "") ].joined(separator: "|§|")
//                    return !existingKeys.contains(key)
//                }
//
//                // Play sound if any of the new messages is incoming (not from me)
//                if newMessages.contains(where: { !($0.isFromMe) }) {
//                    if self.didInitialFirestoreLoad == true{
//                        SoundPlayer.shared.play(.receive)
//                    }
//                }
//
//                self.ChatMessages?.MessagesList = unique
//                print("[ChatsViewModel] Firestore listener: Updated ChatMessages with \(unique.count) unique messages.")
//            }
//            
//        }
//    }
//    
//    func stopListening() {
//        print("[ChatsViewModel] stopListening: Removing Firestore listener if any.")
//        firestoreListener?.remove()
//        firestoreListener = nil
//        didInitialFirestoreLoad = false
//    }
//    
//    private func sendMessageToFirestore(_ message: ChatsMessageItemM) {
//        guard let customerPackageId = CustomerPackageId else {
//            print("[ChatsViewModel] sendMessageToFirestore: CustomerPackageId is nil, cannot send.")
//            return
//        }
//        let db = Firestore.firestore()
//        var data: [String: Any] = [
//            "customerPackageID": message.customerPackageID ?? 0,
//            "comment": message.comment ?? "",
//            "sendByCustomer": message.sendByCustomer ?? false,
//            "sendByDoctor": message.sendByDoctor ?? false,
//            "doctorID": message.doctorID ?? 0,
//            "creationDate": message.creationDate ?? "",
//            "customerName": message.customerName ?? "",
//            "doctorName": message.doctorName ?? "",
//            "serverTimestamp": FieldValue.serverTimestamp()
//        ]
//        if let voicePath = message.voicePath {
//            data["voicePath"] = voicePath
//        }
//        // Note: Not including images in this Firestore message
//        
//        db.collection("chats")
//            .document("\(customerPackageId)")
//            .collection("messages")
//            .addDocument(data: data) { error in
//                if let error = error {
//                    print("[ChatsViewModel] sendMessageToFirestore: Error sending message to Firestore: \(error.localizedDescription)")
//                } else {
//                    SoundPlayer.shared.play(.send)
//                    
//                    print("[ChatsViewModel] sendMessageToFirestore: Successfully sent message to Firestore.")
//                }
//            }
//    }
//}
//
////MARK: -- Functions --
//extension ChatsViewModel {
//
//    @MainActor
//    func getMessages() async {
//        // Cancel any in-flight unified load to prevent overlap
//        loadTask?.cancel()
//        loadTask = Task { [weak self] in
//            guard let self else { return }
//            if self.isLoading == true { return }
////            didInitialFirestoreLoad = true
//            isLoading = true
//            defer { isLoading = false }
//            guard let CustomerPackageId = CustomerPackageId else {
//                return
//            }
//            let parametersarr: [String: Any] = ["CustomerPackageId": CustomerPackageId]
//
//            let target = SubscriptionServices.GetMessage(parameters: parametersarr)
//            do {
//                self.errorMessage = nil // Clear previous errors
//                let response = try await networkService.request(
//                    target,
//                    responseType: ChatsMessageM.self
//                )
//                let messaages = response?.MessagesList?.compactMap({($0.messageText.count > 0 || $0.voicePath?.count ?? 0 > 0) ? $0 : nil})
//                self.ChatMessages = ChatsMessageM(name: response?.name, image: response?.image, MessagesList: messaages)
////                self.startListeningForMessages()
//                didInitialFirestoreLoad = true
//                
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
//            return
//        }
//        var parts: [MultipartFormDataPart] = [
//            .init(name: "CustomerPackageId", value: "\(CustomerPackageId)")
//        ]
//
//        if inputText.count > 0 {
//            parts.append(.init(name: "Comment", value: inputText))
//        }
//
//        if let recordingURL = recordingURL,
//           let fileData = try? Data(contentsOf: recordingURL) {
//            print("recordingURL: \(recordingURL)")
//            print("fileData: \(fileData)")
//
//            parts.append(
//                .init(name: "VoicePath", filename: "voice.mp3", mimeType: "audio/m4a", data: fileData)
//            )
//        }
//
//        print("parts: \(parts)")
//
//        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.uploadMultipart(target, parts: parts, responseType: ChatsMessageItemM.self)
//            if let newMessage = response {
//                if self.ChatMessages?.MessagesList == nil { self.ChatMessages?.MessagesList = [] }
//                self.ChatMessages?.MessagesList?.append(newMessage)
//                sendMessageToFirestore(newMessage)
////                SoundPlayer.shared.playIncoming()
//                // 🔔 Sound for SEND
////                SoundPlayer.shared.playIncoming()
//                
//            } else {
//                // Also play a sound on optimistic send if needed in your other flow
////                SoundPlayer.shared.playIncoming()
//            }
//            self.inputText = ""
//            self.recordingURL = nil
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//}
//
//extension ChatsViewModel {
//
//    @MainActor
//    func refresh() async {
//        await getMessages()
//    }
//}
//
//// Minimal failable initializer for ChatsMessageM from Firestore data
//extension ChatsMessageItemM {
//    init?(fromFirestoreData data: [String: Any]) {
//        func intFrom(_ any: Any?) -> Int? {
//            if let i = any as? Int { return i }
//            if let d = any as? Double { return Int(d) }
//            if let s = any as? String { return Int(s) }
//            return nil
//        }
//        self.customerPackageID = intFrom(data["customerPackageID"])
//        self.comment = data["comment"] as? String
//        self.sendByCustomer = data["sendByCustomer"] as? Bool
//        self.sendByDoctor = data["sendByDoctor"] as? Bool
//        self.voicePath = data["voicePath"] as? String
//        self.doctorID = intFrom(data["doctorID"])
//        self.creationDate = data["creationDate"] as? String
//        self.customerName = data["customerName"] as? String
//        self.doctorName = data["doctorName"] as? String
//        self.customerImage = nil
//        self.doctorImage = nil
//        
//        // If both comment and voicePath are empty or nil, discard
//        if (self.comment?.isEmpty ?? true) && (self.voicePath?.isEmpty ?? true) {
//            return nil
//        }
//    }
//}
//
//
//
//
//
//import AVFoundation
//enum ChatSoundType {
//    case send
//    case receive
//}
//
//import AVFoundation
//import AudioToolbox
//
//final class SoundPlayer {
//
//    static let shared = SoundPlayer()
//
//    private var player: AVAudioPlayer?
//    private var audioSessionConfigured = false
//
//    // MARK: - Public
//    func play(_ type: ChatSoundType) {
//        configureAudioSessionIfNeeded()
//
//        let soundName: String
//        let fallbackSystemSound: SystemSoundID
//
//        switch type {
//        case .send:
//            soundName = "send"
//            fallbackSystemSound = 1004
//        case .receive:
//            soundName = "incoming"
//            fallbackSystemSound = 1007
//        }
//
//        guard let url = Bundle.main.url(forResource: soundName, withExtension: "caf") else {
//            fallback(systemSound: fallbackSystemSound)
//            return
//        }
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.prepareToPlay()
//            player?.play()
//        } catch {
//            fallback(systemSound: fallbackSystemSound)
//        }
//    }
//
//    // MARK: - Private
//    private func configureAudioSessionIfNeeded() {
//        guard !audioSessionConfigured else { return }
//
//        do {
//            let session = AVAudioSession.sharedInstance()
//
//            try session.setCategory(
//                .ambient,
//                mode: .default,
//                options: [.mixWithOthers]
//            )
//
//            try session.setActive(true)
//            audioSessionConfigured = true
//
//        } catch {
//            print("Audio session error: \(error)")
//        }
//    }
//
//    private func fallback(systemSound: SystemSoundID) {
//        AudioServicesPlaySystemSound(systemSound)
//    }
//}



//=-=-=-==============================================

import Foundation
import FirebaseFirestore
import FirebaseCore

class ChatsViewModel: ObservableObject {
    static let shared = ChatsViewModel()
    
    // MARK: - Properties
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void, Never>? = nil
    private var firestoreListener: ListenerRegistration? = nil
    
    // Track if initial load is complete (both API and first Firestore snapshot)
    private var hasCompletedInitialLoad = false
    private var hasProcessedFirstFirestoreSnapshot = false
    
    // Track message IDs we've already seen to prevent duplicate sound effects
    private var seenMessageKeys = Set<String>()
    
    var CustomerPackageId: Int? {
        didSet {
            if CustomerPackageId != nil {
                // Reset state when package changes
                hasCompletedInitialLoad = false
                hasProcessedFirstFirestoreSnapshot = false
                seenMessageKeys.removeAll()
            } else {
                stopListening()
            }
        }
    }
    
    @Published var inputText: String = ""
    @Published var recordingURL: URL? = nil
    @Published var ChatMessages: ChatsMessageM?
    @Published var CreatedMessage: ChatsMessageM?
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Init
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Configuration
    func configure(customerPackageId: Int) {
        self.CustomerPackageId = customerPackageId
    }
    
    // MARK: - Firestore Listener
    func startListeningForMessages() {
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] startListeningForMessages: CustomerPackageId is nil")
            return
        }
        
        print("[ChatsViewModel] Starting Firestore listener for package: \(customerPackageId)")
        
        // Remove existing listener
        firestoreListener?.remove()
        firestoreListener = nil
        
        let db = Firestore.firestore()
        let query = db
            .collection("chats")
            .document("\(customerPackageId)")
            .collection("messages")
            .order(by: "serverTimestamp", descending: false)
        
        firestoreListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("[ChatsViewModel] Firestore error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("[ChatsViewModel] No documents in snapshot")
                return
            }
            
            // Parse all messages from Firestore
            let parsedMessages = documents.compactMap { doc -> ChatsMessageItemM? in
                ChatsMessageItemM(fromFirestoreData: doc.data())
            }
            
            print("[ChatsViewModel] Firestore snapshot received: \(parsedMessages.count) messages")
            
            DispatchQueue.main.async {
                // Mark first Firestore snapshot as processed (no sounds for initial sync)
                if !self.hasProcessedFirstFirestoreSnapshot {
                    print("[ChatsViewModel] Processing FIRST Firestore snapshot - marking all as seen")
                    self.processFirstFirestoreSnapshot(parsedMessages)
                } else {
                    print("[ChatsViewModel] Processing subsequent Firestore snapshot")
                    self.processIncomingMessages(parsedMessages)
                }
            }
        }
    }
    
    // MARK: - Process First Firestore Snapshot (No Sounds)
    private func processFirstFirestoreSnapshot(_ firestoreMessages: [ChatsMessageItemM]) {
        print("[ChatsViewModel] 🔵 Processing first Firestore snapshot")
        
        // Get existing messages from API
        let existingMessages = ChatMessages?.MessagesList ?? []
        
        print("[ChatsViewModel] Existing from API: \(existingMessages.count)")
        print("[ChatsViewModel] From Firestore: \(firestoreMessages.count)")
        
        // DON'T combine - just use API messages as source of truth
        // Firestore is just for real-time updates, not initial load
        let uniqueMessages = deduplicateMessages(existingMessages)
        
        // Mark ALL messages as seen (from API and any potential Firestore messages)
        for msg in uniqueMessages {
            let key = createMessageKey(from: msg)
            seenMessageKeys.insert(key)
        }
        
        // Also mark Firestore messages as seen (even if not in final list)
        for msg in firestoreMessages {
            let key = createMessageKey(from: msg)
            seenMessageKeys.insert(key)
        }
        
        // Update the message list with deduplicated API messages only
        ChatMessages?.MessagesList = uniqueMessages
        
        // Mark first snapshot as processed
        hasProcessedFirstFirestoreSnapshot = true
        
        print("[ChatsViewModel] ✅ First snapshot processed: \(uniqueMessages.count) unique messages displayed")
        print("[ChatsViewModel] ✅ Total keys marked as seen: \(seenMessageKeys.count)")
    }
    
    // MARK: - Process Incoming Messages (With Sounds)
    private func processIncomingMessages(_ firestoreMessages: [ChatsMessageItemM]) {
        print("[ChatsViewModel] 🟢 Processing incoming Firestore messages: \(firestoreMessages.count)")
        
        let existingMessages = ChatMessages?.MessagesList ?? []
        
        print("[ChatsViewModel] Current messages in list: \(existingMessages.count)")
        
        // DON'T combine all messages - instead, only add truly NEW messages from Firestore
        // that aren't already in our list
        
        // Identify truly new messages from Firestore (not seen before)
        var newMessagesToAdd: [ChatsMessageItemM] = []
        
        for firestoreMsg in firestoreMessages {
            let key = createMessageKey(from: firestoreMsg)
            
            // If we haven't seen this message before, it's new
            if !seenMessageKeys.contains(key) {
                newMessagesToAdd.append(firestoreMsg)
                seenMessageKeys.insert(key)
                print("[ChatsViewModel] 🆕 New message detected from Firestore: \(key)")
            }
        }
        
        print("[ChatsViewModel] New messages to add: \(newMessagesToAdd.count)")
        
        // Only update if there are new messages
        if !newMessagesToAdd.isEmpty {
            // Add new messages to existing list
            var updatedMessages = existingMessages + newMessagesToAdd
            
            // Sort by creation date
            updatedMessages.sort { ($0.creationDate ?? "") < ($1.creationDate ?? "") }
            
            // Update the list
            ChatMessages?.MessagesList = updatedMessages
            
            print("[ChatsViewModel] ✅ Updated message list to \(updatedMessages.count) messages")
            
            // Play sound for incoming messages (not from me)
//            if hasCompletedInitialLoad && hasProcessedFirstFirestoreSnapshot {
//                playIncomingSoundIfNeeded(for: newMessagesToAdd)
//            }
        } else {
            print("[ChatsViewModel] No new messages to add")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Deduplicates messages based on unique key and returns sorted array
    private func deduplicateMessages(_ messages: [ChatsMessageItemM]) -> [ChatsMessageItemM] {
        var seen = [String: ChatsMessageItemM]()
        var duplicateCount = 0
        
        for (index, msg) in messages.enumerated() {
            let key = createMessageKey(from: msg)
            
            // Debug: Print duplicate detection
            if seen[key] != nil {
                duplicateCount += 1
                print("[ChatsViewModel] ⚠️ Duplicate #\(duplicateCount) at index \(index)")
                print("    Key: \(key)")
                print("    Comment: \(msg.comment ?? "nil")")
                print("    Date: \(msg.creationDate ?? "nil")")
            }
            
            // Keep first occurrence
            if seen[key] == nil {
                seen[key] = msg
            }
        }
        
        print("[ChatsViewModel] Deduplication: \(messages.count) messages → \(seen.count) unique (\(duplicateCount) duplicates removed)")
        
        // Sort by creation date
        return seen.values.sorted {
            ($0.creationDate ?? "") < ($1.creationDate ?? "")
        }
    }
    
    /// Creates a unique key for a message to prevent duplicates
    private func createMessageKey(from message: ChatsMessageItemM) -> String {
        // Use multiple fields to create a stable unique identifier
        // Try using just the most stable fields first
        let creationDate = message.creationDate ?? ""
        let comment = message.comment ?? ""
        let voicePath = message.voicePath ?? ""
        let packageId = "\(message.customerPackageID ?? 0)"
        
        // Simple key based on content and timestamp
        let key = [creationDate, comment, voicePath, packageId].joined(separator: "|§|")
        
        return key
    }
    
    /// Plays incoming sound only for messages not sent by current user
    private func playIncomingSoundIfNeeded(for messages: [ChatsMessageItemM]) {
        let hasIncomingMessage = messages.contains { !($0.isFromMe) }
        
        if hasIncomingMessage {
            print("[ChatsViewModel] 🔔 Playing RECEIVE sound for incoming message")
            SoundPlayer.shared.play(.receive)
        }
    }
    
    // MARK: - Stop Listening
    func stopListening() {
        print("[ChatsViewModel] Stopping Firestore listener")
        firestoreListener?.remove()
        firestoreListener = nil
        hasCompletedInitialLoad = false
        hasProcessedFirstFirestoreSnapshot = false
        seenMessageKeys.removeAll()
    }
    
    // MARK: - Send to Firestore
    private func sendMessageToFirestore(_ message: ChatsMessageItemM) {
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] Cannot send to Firestore: CustomerPackageId is nil")
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
        
        db.collection("chats")
            .document("\(customerPackageId)")
            .collection("messages")
            .addDocument(data: data) { error in
                if let error = error {
                    print("[ChatsViewModel] Firestore send error: \(error.localizedDescription)")
                } else {
                    print("[ChatsViewModel] Message sent to Firestore successfully")
                }
            }
    }
    
    // MARK: - Cleanup
    func cleanup() {
        print("[ChatsViewModel] Cleanup called")
        stopListening()
        ChatMessages = nil
        inputText = ""
        recordingURL = nil
        errorMessage = nil
    }
}

// MARK: - API Functions
extension ChatsViewModel {
    
    @MainActor
    func getMessages() async {
        // Cancel any in-flight load
        loadTask?.cancel()
        
        loadTask = Task { [weak self] in
            guard let self else { return }
            
            if self.isLoading == true {
                print("[ChatsViewModel] Already loading, skipping")
                return
            }
            
            isLoading = true
            defer { isLoading = false }
            
            guard let customerPackageId = CustomerPackageId else {
                print("[ChatsViewModel] Cannot load messages: CustomerPackageId is nil")
                return
            }
            
            let parameters: [String: Any] = ["CustomerPackageId": customerPackageId]
            let target = SubscriptionServices.GetMessage(parameters: parameters)
            
            do {
                self.errorMessage = nil
                
                print("[ChatsViewModel] Fetching messages from API...")
                
                let response = try await networkService.request(
                    target,
                    responseType: ChatsMessageM.self
                )
                
                // Filter out empty messages
                let validMessages = response?.MessagesList?.compactMap { message in
                    (message.messageText.count > 0 || message.voicePath?.count ?? 0 > 0) ? message : nil
                } ?? []
                
                print("[ChatsViewModel] API returned: \(response?.MessagesList?.count ?? 0) messages")
                print("[ChatsViewModel] Valid messages (non-empty): \(validMessages.count)")
                
                // Deduplicate messages from API response
                let uniqueValidMessages = self.deduplicateMessages(validMessages)
                
                print("[ChatsViewModel] After deduplication: \(uniqueValidMessages.count)")
                
                self.ChatMessages = ChatsMessageM(
                    name: response?.name,
                    image: response?.image,
                    MessagesList: uniqueValidMessages
                )
                
                // CRITICAL: Mark all API messages as "seen" BEFORE starting Firestore
                for msg in uniqueValidMessages {
                    let key = self.createMessageKey(from: msg)
                    self.seenMessageKeys.insert(key)
                }
                
                print("[ChatsViewModel] ✅ Loaded \(uniqueValidMessages.count) unique messages from API")
                print("[ChatsViewModel] ✅ Marked \(self.seenMessageKeys.count) messages as seen")
                
                // Mark initial API load as complete
                self.hasCompletedInitialLoad = true
                
                // Start Firestore listener (first snapshot will be processed without sounds)
                self.startListeningForMessages()
                
            } catch {
                self.errorMessage = error.localizedDescription
                print("[ChatsViewModel] ❌ Error loading messages: \(error.localizedDescription)")
            }
        }
        
        await loadTask?.value
    }
    
    @MainActor
    func createCustomerMessage() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let customerPackageId = CustomerPackageId else {
            print("[ChatsViewModel] Cannot create message: CustomerPackageId is nil")
            return
        }
        
        var parts: [MultipartFormDataPart] = [
            .init(name: "CustomerPackageId", value: "\(customerPackageId)")
        ]
        
        // Add text if present
        if inputText.count > 0 {
            parts.append(.init(name: "Comment", value: inputText))
        }
        
        // Add voice recording if present
        if let recordingURL = recordingURL,
           let fileData = try? Data(contentsOf: recordingURL) {
            parts.append(
                .init(name: "VoicePath", filename: "voice.mp3", mimeType: "audio/m4a", data: fileData)
            )
        }
        
        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
        
        do {
            self.errorMessage = nil
            
            print("[ChatsViewModel] 📤 Sending message to API...")
            
            let response = try await networkService.uploadMultipart(
                target,
                parts: parts,
                responseType: ChatsMessageItemM.self
            )
            
            if let newMessage = response {
                print("[ChatsViewModel] ✅ API returned new message")
                
                // Create message key first
                let key = createMessageKey(from: newMessage)
                
                // Check if message already exists in the list
                let alreadyExists = self.ChatMessages?.MessagesList?.contains { msg in
                    createMessageKey(from: msg) == key
                } ?? false
                
                if !alreadyExists {
                    print("[ChatsViewModel] ➕ Adding new message to local list")
                    
                    // Initialize if needed
                    if self.ChatMessages?.MessagesList == nil {
                        self.ChatMessages?.MessagesList = []
                    }
                    
                    // Add the message
                    self.ChatMessages?.MessagesList?.append(newMessage)
                    
                    // Sort messages by creation date
                    self.ChatMessages?.MessagesList?.sort {
                        ($0.creationDate ?? "") < ($1.creationDate ?? "")
                    }
                } else {
                    print("[ChatsViewModel] ⚠️ Message already exists in list, skipping add")
                }
                
                // CRITICAL: Mark this message as seen IMMEDIATELY
                // This prevents duplication when Firestore listener picks it up
                seenMessageKeys.insert(key)
                print("[ChatsViewModel] ✅ Marked message as seen (key: \(key))")
                
                // Send to Firestore (this will trigger the listener, but won't add duplicate)
                sendMessageToFirestore(newMessage)
                
                // Play SEND sound
                print("[ChatsViewModel] 🔊 Playing SEND sound")
                SoundPlayer.shared.play(.send)
            }
            
            // Clear input fields
            self.inputText = ""
            self.recordingURL = nil
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("[ChatsViewModel] ❌ Error creating message: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func refresh() async {
        await getMessages()
    }
}

// MARK: - Firestore Data Parsing
extension ChatsMessageItemM {
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
        
        // Discard empty messages
        if (self.comment?.isEmpty ?? true) && (self.voicePath?.isEmpty ?? true) {
            return nil
        }
    }
}

// MARK: - Sound Player
import AVFoundation
import AudioToolbox

enum ChatSoundType {
    case send
    case receive
}

final class SoundPlayer {
    static let shared = SoundPlayer()
    
    private var player: AVAudioPlayer?
    private var audioSessionConfigured = false
    
    func play(_ type: ChatSoundType) {
        configureAudioSessionIfNeeded()
        
        let soundName: String
        let fallbackSystemSound: SystemSoundID
        
        switch type {
        case .send:
            soundName = "send"
            fallbackSystemSound = 1004
        case .receive:
            soundName = "incoming"
            fallbackSystemSound = 1007
        }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "caf") else {
            fallback(systemSound: fallbackSystemSound)
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            fallback(systemSound: fallbackSystemSound)
        }
    }
    
    private func configureAudioSessionIfNeeded() {
        guard !audioSessionConfigured else { return }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            audioSessionConfigured = true
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    private func fallback(systemSound: SystemSoundID) {
        AudioServicesPlaySystemSound(systemSound)
    }
}
