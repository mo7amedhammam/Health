//
//  ChatsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
//import AVFoundation


class ChatsViewModel: ObservableObject {
    static let shared = ChatsViewModel()
    // Removed old network service dependency and related property
    
    private var listener: ListenerRegistration? = nil
    
    var CustomerPackageId: Int?
    
    @Published var inputText: String = ""
    @Published var recordingURL: URL? = nil
    
    // Published properties
    @Published var ChatMessages: [ChatsMessageM]?
    
    @Published var CreatedMessage: ChatsMessageM?
   
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init without any dependency
    init() {
        // No network service dependency anymore
    }
}

//MARK: -- Functions --
extension ChatsViewModel {
    
    /// Starts listening for chat messages for a given chat ID using Firestore real-time updates.
    /// - Parameter chatId: The identifier for the chat session (e.g., customer package ID as string).
    @MainActor
    func listenForMessages(chatId: String) {
        // Stop any previous listener first
        stopListening()
        
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        listener = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "creationDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                guard let documents = snapshot?.documents else {
                    self.ChatMessages = []
                    self.isLoading = false
                    return
                }
                var messages: [ChatsMessageM] = []
                for doc in documents {
                    let data = doc.data()
                    // Parsing fields safely and mapping to ChatsMessageM
                    let customerPackageID = data["customerPackageID"] as? Int ?? 0
                    let comment = data["comment"] as? String ?? ""
                    let sendByCustomer = data["sendByCustomer"] as? Bool ?? false
                    let sendByDoctor = data["sendByDoctor"] as? Bool ?? false
                    let voicePath = data["voicePath"] as? String
                    let doctorID = data["doctorID"] as? Int ?? 0
                    let creationDate = data["creationDate"] as? String ?? ""
                    let customerName = data["customerName"] as? String
                    let doctorName = data["doctorName"] as? String
                    let customerImage = data["customerImage"] as? String
                    let doctorImage = data["doctorImage"] as? String
                    
                    // Only include messages with text or voicePath
                    if !comment.isEmpty || (voicePath?.count ?? 0) > 0 {
                        let message = ChatsMessageM(
                            customerPackageID: customerPackageID,
                            comment: comment,
                            sendByCustomer: sendByCustomer,
                            sendByDoctor: sendByDoctor,
                            voicePath: voicePath,
                            doctorID: doctorID,
                            creationDate: creationDate,
                            customerName: customerName,
                            doctorName: doctorName,
                            customerImage: customerImage,
                            doctorImage: doctorImage
                        )
                        messages.append(message)
                    }
                }
                self.ChatMessages = messages
                self.isLoading = false
            }
    }
    
    /// Stops listening for real-time chat message updates.
    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    /// Creates a new customer message, uploading voice data if present, and adds it to Firestore.
    @MainActor
    func createCustomerMessage() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let CustomerPackageId = CustomerPackageId else {
            return
        }
        let chatId = String(CustomerPackageId)
        let db = Firestore.firestore()
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        
        var newMessageData: [String: Any] = [
            "customerPackageID": CustomerPackageId,
            "sendByCustomer": true,
            "sendByDoctor": false,
            "doctorID": 0, // adjust if needed
            "creationDate": ISO8601DateFormatter().string(from: Date()),
            "customerName": nil as String?,
            "doctorName": nil as String?,
            "customerImage": nil as String?,
            "doctorImage": nil as String?
        ]
        
        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newMessageData["comment"] = inputText
        }
        
        if let recordingURL = recordingURL {
            do {
                let fileData = try Data(contentsOf: recordingURL)
                let storageRef = Storage.storage().reference().child("chatVoiceMessages").child(chatId).child("\(UUID().uuidString).m4a")
                
                let metadata = StorageMetadata()
                metadata.contentType = "audio/m4a"
                
                // Upload voice message asynchronously
                let _ = try await storageRef.putDataAsync(fileData, metadata: metadata)
                let downloadURL = try await storageRef.downloadURL()
                
                newMessageData["voicePath"] = downloadURL.absoluteString
            } catch {
                self.errorMessage = error.localizedDescription
                return
            }
        }
        
        do {
            let docRef = try await messagesRef.addDocument(data: newMessageData)
            // Optionally fetch created message
            let docSnapshot = try await docRef.getDocument()
            if let data = docSnapshot.data() {
                let message = ChatsMessageM(
                    customerPackageID: data["customerPackageID"] as? Int ?? 0,
                    comment: data["comment"] as? String ?? "",
                    sendByCustomer: data["sendByCustomer"] as? Bool ?? false,
                    sendByDoctor: data["sendByDoctor"] as? Bool ?? false,
                    voicePath: data["voicePath"] as? String,
                    doctorID: data["doctorID"] as? Int ?? 0,
                    creationDate: data["creationDate"] as? String ?? "",
                    customerName: data["customerName"] as? String,
                    doctorName: data["doctorName"] as? String,
                    customerImage: data["customerImage"] as? String,
                    doctorImage: data["doctorImage"] as? String
                )
                self.CreatedMessage = message
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
        // With Firebase real-time listener, refresh can be no-op or restart listener if needed.
        if let CustomerPackageId = CustomerPackageId {
            listenForMessages(chatId: String(CustomerPackageId))
        }
    }

    // Commented out old load more logic
//    @MainActor
//    func loadMoreIfNeeded() async {
//        guard !(isLoading ?? false),
//              let currentCount = appointments?.items?.count,
//              let totalCount = appointments?.totalCount,
//              currentCount < totalCount,
//              let maxResultCount = maxResultCount else { return }
//
//        skipCount = (skipCount ?? 0) + maxResultCount
//        await getAppointmenstList()
//    }
}

