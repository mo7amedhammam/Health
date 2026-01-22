//
//  VoicePlayerManager.swift
//  Sehaty
//
//  Created by mohamed hammam on 21/01/2026.
//

//import Combine
import AVFoundation

class VoicePlayerManager: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var isLoading = false
    @Published var currentTime: Double = 0
    @Published var totalDuration: Double = 0

    private var player: AVPlayer?
    private var timeObserverToken: Any?

    private static var activePlayer: VoicePlayerManager?

    func play(from url: URL) {
        // Stop previous active
        if let previous = VoicePlayerManager.activePlayer, previous !== self {
            previous.stop()
        }
        VoicePlayerManager.activePlayer = self

        stop()
        isLoading = true

        let fileName = url.lastPathComponent
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: localURL.path) {
            print("✅ Loaded from cache: \(fileName)")
            playLocalFile(localURL)
        } else {
            print("⬇️ Downloading: \(url.absoluteString)")
            downloadAndPlay(from: url, saveTo: localURL)
        }
    }

    private func downloadAndPlay(from remoteURL: URL, saveTo localURL: URL) {
        URLSession.shared.dataTask(with: remoteURL) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("❌ Failed to download: \(error?.localizedDescription ?? "")")
                }
                return
            }

            do {
                try data.write(to: localURL)
                print("📁 Saved to cache: \(localURL.lastPathComponent)")
                DispatchQueue.main.async {
                    self.playLocalFile(localURL)
                }
            } catch {
                print("❌ Failed to write file: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func playLocalFile(_ localURL: URL) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("⚠️ AVAudioSession error: \(error.localizedDescription)")
        }

        let asset = AVAsset(url: localURL)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)

        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            DispatchQueue.main.async {
                var error: NSError?
                let status = asset.statusOfValue(forKey: "duration", error: &error)

                if status == .loaded {
                    self.totalDuration = asset.duration.seconds
                    self.addTimeObserver()
                    self.player?.play()
                    self.isPlaying = true
                    self.isLoading = false
                } else {
                    print("⚠️ Failed to load duration: \(error?.localizedDescription ?? "")")
                    self.isLoading = false
                }
            }
        }

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.stop()
        }
    }

    private func addTimeObserver() {
        guard let player = player else { return }

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self, let duration = player.currentItem?.duration.seconds, duration > 0 else { return }
            self.currentTime = time.seconds
            self.progress = time.seconds / duration
        }
    }

    func seek(to time: Double) {
        guard let player = player, time.isFinite else { return }

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
        currentTime = time
        progress = time / totalDuration
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        progress = 0
        currentTime = 0
        totalDuration = 0
        isLoading = false

        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }

        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        stop()
    }

    func formatTime(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "0:00"
    }
}


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


//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------

//class ChatsViewModel: ObservableObject {
//    static let shared = ChatsViewModel()
//    // Removed old network service dependency and related property
//
//    private var listener: ListenerRegistration? = nil
//
//    var CustomerPackageId: Int?
//
//    @Published var inputText: String = ""
//    @Published var recordingURL: URL? = nil
//
//    // Published properties
//    @Published var ChatMessages: [ChatsMessageM]?
//
//    @Published var CreatedMessage: ChatsMessageM?
//
//    @Published var isLoading: Bool? = false
//    @Published var errorMessage: String? = nil
//
//    // Init without any dependency
//    init() {
//        // No network service dependency anymore
//    }
//}

//MARK: -- Functions --
//extension ChatsViewModel {
//
//    /// Starts listening for chat messages for a given chat ID using Firestore real-time updates.
//    /// - Parameter chatId: The identifier for the chat session (e.g., customer package ID as string).
//    @MainActor
//    func listenForMessages(chatId: String) {
//        // Stop any previous listener first
//        stopListening()
//
//        isLoading = true
//        errorMessage = nil
//
//        let db = Firestore.firestore()
//        listener = db.collection("chats")
//            .document(chatId)
//            .collection("messages")
//            .order(by: "creationDate", descending: false)
//            .addSnapshotListener { [weak self] snapshot, error in
//                guard let self = self else { return }
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    self.isLoading = false
//                    return
//                }
//                guard let documents = snapshot?.documents else {
//                    self.ChatMessages = []
//                    self.isLoading = false
//                    return
//                }
//                var messages: [ChatsMessageM] = []
//                for doc in documents {
//                    let data = doc.data()
//                    // Parsing fields safely and mapping to ChatsMessageM
//                    let customerPackageID = data["customerPackageID"] as? Int ?? 0
//                    let comment = data["comment"] as? String ?? ""
//                    let sendByCustomer = data["sendByCustomer"] as? Bool ?? false
//                    let sendByDoctor = data["sendByDoctor"] as? Bool ?? false
//                    let voicePath = data["voicePath"] as? String
//                    let doctorID = data["doctorID"] as? Int ?? 0
//                    let creationDate = data["creationDate"] as? String ?? ""
//                    let customerName = data["customerName"] as? String
//                    let doctorName = data["doctorName"] as? String
//                    let customerImage = data["customerImage"] as? String
//                    let doctorImage = data["doctorImage"] as? String
//
//                    // Only include messages with text or voicePath
//                    if !comment.isEmpty || (voicePath?.count ?? 0) > 0 {
//                        let message = ChatsMessageM(
//                            customerPackageID: customerPackageID,
//                            comment: comment,
//                            sendByCustomer: sendByCustomer,
//                            sendByDoctor: sendByDoctor,
//                            voicePath: voicePath,
//                            doctorID: doctorID,
//                            creationDate: creationDate,
//                            customerName: customerName,
//                            doctorName: doctorName,
//                            customerImage: customerImage,
//                            doctorImage: doctorImage
//                        )
//                        messages.append(message)
//                    }
//                }
//                self.ChatMessages = messages
//                self.isLoading = false
//            }
//    }
//
//    /// Stops listening for real-time chat message updates.
//    func stopListening() {
//        listener?.remove()
//        listener = nil
//    }
//
//    /// Creates a new customer message, uploading voice data if present, and adds it to Firestore.
//    @MainActor
//    func createCustomerMessage() async {
//        isLoading = true
//        defer { isLoading = false }
//
//        guard let CustomerPackageId = CustomerPackageId else {
//            return
//        }
//        let chatId = String(CustomerPackageId)
//        let db = Firestore.firestore()
//        let messagesRef = db.collection("chats").document(chatId).collection("messages")
//
//        var newMessageData: [String: Any] = [
//            "customerPackageID": CustomerPackageId,
//            "sendByCustomer": true,
//            "sendByDoctor": false,
//            "doctorID": 0, // adjust if needed
//            "creationDate": ISO8601DateFormatter().string(from: Date()),
//            "customerName": nil as String?,
//            "doctorName": nil as String?,
//            "customerImage": nil as String?,
//            "doctorImage": nil as String?
//        ]
//
//        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            newMessageData["comment"] = inputText
//        }
//
//        if let recordingURL = recordingURL {
//            do {
//                let fileData = try Data(contentsOf: recordingURL)
//                let storageRef = Storage.storage().reference().child("chatVoiceMessages").child(chatId).child("\(UUID().uuidString).m4a")
//
//                let metadata = StorageMetadata()
//                metadata.contentType = "audio/m4a"
//
//                // Upload voice message asynchronously
//                let _ = try await storageRef.putDataAsync(fileData, metadata: metadata)
//                let downloadURL = try await storageRef.downloadURL()
//
//                newMessageData["voicePath"] = downloadURL.absoluteString
//            } catch {
//                self.errorMessage = error.localizedDescription
//                return
//            }
//        }
//
//        do {
//            let docRef = try await messagesRef.addDocument(data: newMessageData)
//            // Optionally fetch created message
//            let docSnapshot = try await docRef.getDocument()
//            if let data = docSnapshot.data() {
//                let message = ChatsMessageM(
//                    customerPackageID: data["customerPackageID"] as? Int ?? 0,
//                    comment: data["comment"] as? String ?? "",
//                    sendByCustomer: data["sendByCustomer"] as? Bool ?? false,
//                    sendByDoctor: data["sendByDoctor"] as? Bool ?? false,
//                    voicePath: data["voicePath"] as? String,
//                    doctorID: data["doctorID"] as? Int ?? 0,
//                    creationDate: data["creationDate"] as? String ?? "",
//                    customerName: data["customerName"] as? String,
//                    doctorName: data["doctorName"] as? String,
//                    customerImage: data["customerImage"] as? String,
//                    doctorImage: data["doctorImage"] as? String
//                )
//                self.CreatedMessage = message
//            }
//            self.inputText = ""
//            self.recordingURL = nil
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//}

//extension ChatsViewModel {
//
//    @MainActor
//    func refresh() async {
//        // With Firebase real-time listener, refresh can be no-op or restart listener if needed.
//        if let CustomerPackageId = CustomerPackageId {
//            listenForMessages(chatId: String(CustomerPackageId))
//        }
//    }
//
//    // Commented out old load more logic
////    @MainActor
////    func loadMoreIfNeeded() async {
////        guard !(isLoading ?? false),
////              let currentCount = appointments?.items?.count,
////              let totalCount = appointments?.totalCount,
////              currentCount < totalCount,
////              let maxResultCount = maxResultCount else { return }
////
////        skipCount = (skipCount ?? 0) + maxResultCount
////        await getAppointmenstList()
////    }
//}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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
//
//        let target = SubscriptionServices.CreateCustomerMessage(parameters: parts)
//        do {
//            self.errorMessage = nil // Clear previous errors
////            let response = try await networkService.request(
////                target,
////                responseType: [ChatsMessageM].self
////            )
//            _ = try await networkService.uploadMultipart(target
//                                                         , parts: parts
//                                                         , responseType: ChatsMessageM.self)
////            self.ChatMessages = response
//            self.inputText = ""
//            self.recordingURL = nil
//            await getMessages()
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
