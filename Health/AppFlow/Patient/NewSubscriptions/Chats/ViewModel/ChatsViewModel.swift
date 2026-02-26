//
//  ChatsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

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
            
            // Parse all messages from Firestore — capture firestoreDocumentID from each doc
            let parsedMessages: [(msg: ChatsMessageItemM, docID: String)] = documents.compactMap { doc in
                guard let msg = ChatsMessageItemM(fromFirestoreData: doc.data()) else { return nil }
                return (msg, doc.documentID)
            }
            
            print("[ChatsViewModel] Firestore snapshot received: \(parsedMessages.count) messages")
            
            DispatchQueue.main.async {
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
    private func processFirstFirestoreSnapshot(_ firestoreMessages: [(msg: ChatsMessageItemM, docID: String)]) {
        print("[ChatsViewModel] 🔵 Processing first Firestore snapshot")
        
        let existingMessages = ChatMessages?.MessagesList ?? []
        let uniqueMessages = deduplicateMessages(existingMessages)
        
        // Mark ALL existing messages as seen
        for msg in uniqueMessages {
            seenMessageKeys.insert(createMessageKey(from: msg))
        }
        
        // Mark all Firestore doc IDs as seen (the stable key)
        for (msg, docID) in firestoreMessages {
            seenMessageKeys.insert(docID)                          // stable Firestore doc ID
            seenMessageKeys.insert(createMessageKey(from: msg))    // content-based fallback
        }
        
        ChatMessages?.MessagesList = uniqueMessages
        hasProcessedFirstFirestoreSnapshot = true
        
        print("[ChatsViewModel] ✅ First snapshot processed: \(uniqueMessages.count) messages")
        print("[ChatsViewModel] ✅ Total keys marked as seen: \(seenMessageKeys.count)")
    }
    
    // MARK: - Process Incoming Messages (With Sounds)
    private func processIncomingMessages(_ firestoreMessages: [(msg: ChatsMessageItemM, docID: String)]) {
        print("[ChatsViewModel] 🟢 Processing incoming Firestore messages: \(firestoreMessages.count)")
        
        let existingMessages = ChatMessages?.MessagesList ?? []
        var newMessagesToAdd: [ChatsMessageItemM] = []
        
        for (firestoreMsg, docID) in firestoreMessages {
            let contentKey = createMessageKey(from: firestoreMsg)
            
            // ✅ Check BOTH the stable Firestore doc ID AND the content-based key.
            // This is the core fix: even if the content key drifts slightly between
            // what the API returned and what Firestore stored, the doc ID is always stable.
            let alreadySeen = seenMessageKeys.contains(docID) || seenMessageKeys.contains(contentKey)
            
            if !alreadySeen {
                newMessagesToAdd.append(firestoreMsg)
                seenMessageKeys.insert(docID)
                seenMessageKeys.insert(contentKey)
                print("[ChatsViewModel] 🆕 New message detected (docID: \(docID))")
            }
        }
        
        print("[ChatsViewModel] New messages to add: \(newMessagesToAdd.count)")
        
        if !newMessagesToAdd.isEmpty {
            var updatedMessages = existingMessages + newMessagesToAdd
            updatedMessages.sort { ($0.creationDate ?? "") < ($1.creationDate ?? "") }
            ChatMessages?.MessagesList = updatedMessages
            
            print("[ChatsViewModel] ✅ Updated message list to \(updatedMessages.count) messages")
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
            if seen[key] != nil {
                duplicateCount += 1
                print("[ChatsViewModel] ⚠️ Duplicate #\(duplicateCount) at index \(index) — key: \(key)")
            }
            if seen[key] == nil {
                seen[key] = msg
            }
        }
        
        print("[ChatsViewModel] Deduplication: \(messages.count) → \(seen.count) (\(duplicateCount) removed)")
        
        return seen.values.sorted { ($0.creationDate ?? "") < ($1.creationDate ?? "") }
    }
    
    /// Creates a unique key for a message based on its content.
    /// NOTE: This is a fallback. Prefer using the Firestore document ID where available.
    private func createMessageKey(from message: ChatsMessageItemM) -> String {
        let creationDate = message.creationDate ?? ""
        let comment = message.comment ?? ""
        let voicePath = message.voicePath ?? ""
        let packageId = "\(message.customerPackageID ?? 0)"
        return [creationDate, comment, voicePath, packageId].joined(separator: "|§|")
    }
    
    /// Plays incoming sound only for messages not sent by current user
    private func playIncomingSoundIfNeeded(for messages: [ChatsMessageItemM]) {
        let hasIncomingMessage = messages.contains { !($0.isFromMe) }
        if hasIncomingMessage {
            print("[ChatsViewModel] 🔔 Playing RECEIVE sound")
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
            // ✅ Store creationDate exactly as received from the API so the content
            // key round-trips correctly when Firestore returns it back to us.
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
                    print("[ChatsViewModel] ✅ Message sent to Firestore")
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
                
                let validMessages = response?.MessagesList?.compactMap { message in
                    (message.messageText.count > 0 || message.voicePath?.count ?? 0 > 0) ? message : nil
                } ?? []
                
                let uniqueValidMessages = self.deduplicateMessages(validMessages)
                
                print("[ChatsViewModel] API: \(response?.MessagesList?.count ?? 0) total → \(uniqueValidMessages.count) unique valid")
                
                self.ChatMessages = ChatsMessageM(
                    name: response?.name,
                    image: response?.image,
                    MessagesList: uniqueValidMessages
                )
                
                // Mark all API messages as seen BEFORE starting Firestore listener
                for msg in uniqueValidMessages {
                    self.seenMessageKeys.insert(self.createMessageKey(from: msg))
                }
                
                print("[ChatsViewModel] ✅ Marked \(self.seenMessageKeys.count) messages as seen")
                
                self.hasCompletedInitialLoad = true
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
        
        if inputText.count > 0 {
            parts.append(.init(name: "Comment", value: inputText))
        }
        
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
                
                let contentKey = createMessageKey(from: newMessage)
                
                // ✅ Mark the content key as seen BEFORE sending to Firestore.
                // When Firestore fires back, we'll also check the doc ID (inserted
                // in processIncomingMessages), so both gates are covered.
                seenMessageKeys.insert(contentKey)
                print("[ChatsViewModel] ✅ Pre-marked content key as seen: \(contentKey)")
                
                let alreadyExists = self.ChatMessages?.MessagesList?.contains { msg in
                    createMessageKey(from: msg) == contentKey
                } ?? false
                
                if !alreadyExists {
                    if self.ChatMessages?.MessagesList == nil {
                        self.ChatMessages?.MessagesList = []
                    }
                    self.ChatMessages?.MessagesList?.append(newMessage)
                    self.ChatMessages?.MessagesList?.sort {
                        ($0.creationDate ?? "") < ($1.creationDate ?? "")
                    }
                    print("[ChatsViewModel] ➕ Message added to local list")
                } else {
                    print("[ChatsViewModel] ⚠️ Message already in list, skipping add")
                }
                
                // Send to Firestore — the returned doc ID will be added to seenMessageKeys
                // the next time processIncomingMessages runs, preventing any second insertion.
                sendMessageToFirestore(newMessage)
                
                print("[ChatsViewModel] 🔊 Playing SEND sound")
                SoundPlayer.shared.play(.send)
            }
            
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
        
        if (self.comment?.isEmpty ?? true) && (self.voicePath?.isEmpty ?? true) {
            return nil
        }
    }
}
