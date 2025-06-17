//
//  ChatsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

import Foundation
import AVFoundation


class ChatsViewModel:ObservableObject {
    static let shared = ChatsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    
    var CustomerPackageId : Int?
    
    @Published var inputText: String = ""
    @Published var recordingURL: URL? = nil
    
    // Published properties
    @Published var ChatMessages: [ChatsMessageM]?
    @Published var CreatedMessage: ChatsMessageM?
   
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension ChatsViewModel{
    
    @MainActor
    func getMessages() async {
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
            _ = try await networkService.uploadMultipart(target
                                                         , parts: parts
                                                         , responseType: ChatsMessageM.self)
//            self.ChatMessages = response
            self.inputText = ""
            self.recordingURL = nil
            await getMessages()
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



class VoicePlayerManager: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var isLoading = false

    private var player: AVPlayer?
    private var timeObserverToken: Any?

    func play(from url: URL) {
        stop()
        isLoading = true

        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)

//        player?.play()
        isPlaying = true
        isLoading = false

        // Observe progress
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self, let duration = self.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            self.progress = time.seconds / duration
        }

        // Observe end
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.stop()
        }
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
}
