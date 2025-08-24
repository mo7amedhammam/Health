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
