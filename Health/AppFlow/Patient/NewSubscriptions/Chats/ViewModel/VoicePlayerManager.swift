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
