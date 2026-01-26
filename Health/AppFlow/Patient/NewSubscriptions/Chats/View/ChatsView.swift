//
//  ChatsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

import SwiftUI
import AVFoundation
import UserNotifications

// MARK: - Audio Manager (Centralized audio handling)
class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingTime: TimeInterval = 0
    @Published var playbackTime: TimeInterval = 0
    @Published var waveformLevel: CGFloat = 0
    @Published var showPermissionAlert = false
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var levelTimer: Timer?
    private var playbackTimer: Timer?
    private var isProcessing = false // Debounce flag
    
    var recordingURL: URL?
    var playbackDuration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            print("✅ Audio session configured successfully")
        } catch {
            print("❌ Audio session setup failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Recording
    func startRecording() {
        guard !isProcessing else {
            print("⚠️ Already processing, ignoring startRecording")
            return
        }
        isProcessing = true
        
        // Stop any existing playback
        stopPlayback()
        
        // Check current permission status first
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        print("🎤 Current microphone permission: \(permissionStatus.rawValue)")
        
        switch permissionStatus {
        case .granted:
            print("✅ Permission already granted, starting recording...")
            DispatchQueue.main.async {
                self.performRecording()
            }
            
        case .denied:
            print("❌ Microphone permission was previously denied")
            print("📱 User needs to enable it in Settings > Privacy > Microphone > Sehaty")
            DispatchQueue.main.async {
                self.isProcessing = false
                self.showPermissionAlert = true
            }
            
        case .undetermined:
            print("❓ Permission not yet requested, requesting now...")
            // Request permission
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        print("✅ Permission granted! Starting recording...")
                        self?.performRecording()
                    } else {
                        print("❌ User denied microphone permission")
                        print("📱 They need to enable it in Settings > Privacy > Microphone > Sehaty")
                        self?.isProcessing = false
                        self?.showPermissionAlert = true
                    }
                }
            }
            
        @unknown default:
            print("⚠️ Unknown permission status")
            isProcessing = false
        }
    }
    
    private func performRecording() {
        let fileName = UUID().uuidString + ".m4a"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        recordingURL = path
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 128000
        ]
        
        do {
            // Activate audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            
            // Initialize recorder
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            
            // Prepare and start
            guard audioRecorder?.prepareToRecord() == true else {
                print("❌ Failed to prepare recorder")
                isProcessing = false
                return
            }
            
            let success = audioRecorder?.record() ?? false
            if success {
                isRecording = true
                recordingTime = 0
                startRecordingTimer()
                startLevelTimer()
                print("🎙 Recording started: \(path.lastPathComponent)")
                print("   Recorder state: \(audioRecorder?.isRecording ?? false)")
            } else {
                print("❌ Failed to start recording - recorder.record() returned false")
            }
            
            // Reset processing flag after a small delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isProcessing = false
            }
        } catch {
            print("❌ Recording setup failed: \(error.localizedDescription)")
            isProcessing = false
        }
    }
    
    func stopRecording() {
        guard isRecording else {
            print("⚠️ stopRecording called but isRecording = false")
            return
        }
        
        print("🛑 Stopping recording...")
        print("   Current recording time: \(recordingTime)s")
        print("   Recorder is recording: \(audioRecorder?.isRecording ?? false)")
        
        audioRecorder?.stop()
        isRecording = false
        
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        levelTimer?.invalidate()
        levelTimer = nil
        waveformLevel = 0
        
        print("✅ Recording stopped: \(recordingURL?.lastPathComponent ?? "unknown")")
        
        // Verify file exists and is valid
        if let url = recordingURL {
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            let fileSize = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64) ?? 0
            print("📁 File exists: \(fileExists), Size: \(fileSize) bytes")
            
            // Try to read the file to ensure it's valid
            if fileExists {
                do {
                    let testPlayer = try AVAudioPlayer(contentsOf: url)
                    print("✅ Audio file is valid - Duration: \(testPlayer.duration)s, Channels: \(testPlayer.numberOfChannels)")
                } catch {
                    print("❌ Audio file validation failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.recordingTime += 1
        }
    }
    
    private func startLevelTimer() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let recorder = self?.audioRecorder else { return }
            recorder.updateMeters()
            let level = recorder.averagePower(forChannel: 0)
            // Normalize from -160 to 0 dB to 0.0 to 1.0
            let normalizedLevel = max(0, (level + 60) / 60)
            self?.waveformLevel = CGFloat(normalizedLevel)
        }
    }
    
    // MARK: - Playback
    func startPlayback() {
        guard let url = recordingURL else {
            print("❌ No recording URL available")
            return
        }
        
        // Verify file exists before attempting playback
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ Recording file not found at: \(url.path)")
            return
        }
        
        do {
            // Keep the same session category, just override the route to speaker
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            
            print("📊 Audio file info:")
            print("   - Duration: \(audioPlayer?.duration ?? 0)s")
            print("   - Format: \(audioPlayer?.format.description ?? "unknown")")
            print("   - Channels: \(audioPlayer?.numberOfChannels ?? 0)")
            
            let success = audioPlayer?.play() ?? false
            if success {
                isPlaying = true
                playbackTime = 0
                startPlaybackTimer()
                print("▶️ Playback started (volume: \(audioPlayer?.volume ?? 0))")
            } else {
                print("❌ Failed to start playback")
            }
        } catch {
            print("❌ Playback failed: \(error.localizedDescription)")
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        playbackTimer?.invalidate()
        playbackTimer = nil
        print("⏸ Playback paused")
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        playbackTime = 0
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    private func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.playbackTime = player.currentTime
            
            if !player.isPlaying {
                self.isPlaying = false
                self.playbackTimer?.invalidate()
                self.playbackTimer = nil
            }
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playbackTime = 0
        playbackTimer?.invalidate()
        playbackTimer = nil
        print("✅ Playback finished")
    }
    
    // MARK: - Utilities
    func deleteRecording() {
        guard let url = recordingURL else { return }
        
        stopRecording()
        stopPlayback()
        
        do {
            try FileManager.default.removeItem(at: url)
            recordingURL = nil
            recordingTime = 0
            playbackTime = 0
            print("🗑 Recording deleted")
        } catch {
            print("❌ Delete failed: \(error.localizedDescription)")
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Waveform View
struct WaveformView: View {
    @StateObject private var viewModel = WaveformViewModel()
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(viewModel.levels.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 4, height: max(viewModel.levels[index], 2))
            }
        }
        .frame(height: 35)
        .onChange(of: isAnimating) { newValue in
            newValue ? viewModel.start() : viewModel.stop()
        }
    }
}

class WaveformViewModel: ObservableObject {
    @Published var levels: [CGFloat] = Array(repeating: 10, count: 15)
    private var timer: Timer?
    
    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            self?.levels = (0..<15).map { _ in CGFloat.random(in: 6...28) }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        levels = Array(repeating: 10, count: 15)
    }
}

// MARK: - Voice Message Player View
struct VoiceMessagePlayerView: View {
    let voiceURL: URL
    let isFromCustomer: Bool
    @StateObject private var player = VoicePlayerManager()
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if player.isPlaying {
                    player.pause()
                } else {
                    player.play(from: voiceURL)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 36, height: 36)
                    if player.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            
            WaveformView(isAnimating: player.isPlaying)
                .padding(.vertical, 4)
        }
        .padding(12)
        .frame(height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isFromCustomer ? Color.mainBlue : Color(.messageSenderBg))
        .cornerRadius(16)
    }
}

// MARK: - Message Bubble View
struct MessageBubbleView: View {
    let message: ChatsMessageItemM
    
    var body: some View {
        HStack {
            if message.isFromMe {
                Spacer()
            }
            
            VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 4) {
                Text(message.formattedDate)
                    .font(.regular(size: 12))
                    .foregroundColor(.gray)
                    .frame(height: 10)
                
                if message.voicePath == nil {
                    Text(message.messageText)
                        .font(.regular(size: 14))
                        .foregroundColor(message.isFromMe ? .white : .black)
                        .padding(12)
                        .background(message.isFromMe ? Color.mainBlue : Color(.messageSenderBg))
                        .cornerRadius(16)
                        .lineSpacing(8)
                } else if let voice = message.voicePath,
                          let voiceURL = URL(string: Constants.baseURL + voice.validateSlashs()) {
                    VoiceMessagePlayerView(voiceURL: voiceURL, isFromCustomer: message.isFromMe)
                        .localizeView()
                }
            }
            .frame(maxWidth: 280, alignment: message.isFromMe ? .trailing : .leading)
            
            if !message.isFromMe {
                Spacer()
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - Messages List View
struct MessagesListView: View {
    var messages: [ChatsMessageItemM]?
    
    var body: some View {
        if let messages = messages, !messages.isEmpty {
            ScrollViewReader { proxy in
                List {
                    ForEach(messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    Color.clear
                        .frame(height: 1)
                        .id("bottomMarker")
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom(proxy: proxy, animated: true)
                }
            }
        } else {
            EmptyMessageBox()
                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if animated {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    proxy.scrollTo("bottomMarker", anchor: .bottom)
                }
            } else {
                proxy.scrollTo("bottomMarker", anchor: .bottom)
            }
        }
    }
}

// MARK: - Empty Message Box
struct EmptyMessageBox: View {
    var body: some View {
        VStack {
            Spacer()
            Image("chats")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(30)
                .frame(width: 162, height: 162)
                .background(Color(.bgPurple).clipShape(Circle()))
                .foregroundColor(Color(.btnDisabledTxt))
            Text("Message box is empty".localized())
                .font(.semiBold(size: 22))
                .foregroundColor(Color(.btnDisabledTxt))
                .padding()
            Spacer()
        }
    }
}

// MARK: - Message Input Field
struct MessageInputField: View {
    @Binding var comment: String
    let onSend: () -> Void
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TextField("Write_a_message".localized, text: $comment, axis: .vertical)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.medium(size: 14))
                .padding(.horizontal)
                .frame(minHeight: 40)
                .background(Color(.messageSenderBg).cornerRadius(7))
                .onSubmit {
                    onSend()
                }
        } else {
            MultilineTextField("Write_a_message".localized, text: $comment, onCommit: onSend)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .frame(minHeight: 40)
                .background(Color(.messageSenderBg).cornerRadius(7))
        }
    }
}

// MARK: - ChatsView
struct ChatsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = ChatsViewModel.shared
    @StateObject private var audioManager = AudioManager()
    
    var CustomerPackageId: Int
    
    var chatwithName: String? {
        viewModel.ChatMessages?.name
    }
    
    var chatwithImage: String? {
        viewModel.ChatMessages?.image
    }
    
    var chatwithStatus: String? {
        viewModel.ChatMessages?.isActive == true ? "Online" : "Offline"
    }
    
    init(CustomerPackageId: Int) {
        self.CustomerPackageId = CustomerPackageId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.backLeft)
                        .resizable()
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .frame(width: 31, height: 31)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(chatwithName ?? "")
                        .font(.bold(size: 20))
                        .foregroundColor(.mainBlue)
                    Text(chatwithStatus?.localized ?? "")
                        .font(.medium(size: 11))
                        .foregroundColor(Color(.secondary))
                }
                
                if let imageUrl = chatwithImage {
                    KFImageLoader(
                        url: URL(string: Constants.imagesURL + imageUrl.validateSlashs()),
                        placeholder: Image("logo"),
                        shouldRefetch: true
                    )
                    .frame(width: 49, height: 49)
                    .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
            
            // MARK: - Messages
            MessagesListView(messages: viewModel.ChatMessages?.MessagesList)
                .refreshable {
                    await viewModel.refresh()
                }
            
            // MARK: - Input Area
            VStack {
                HStack {
                    // Recording/Playback UI
                    if let _ = audioManager.recordingURL {
                        HStack(spacing: 12) {
                            // Recording mode
                            if audioManager.isRecording {
                                HStack(spacing: 10) {
                                    Text(audioManager.formatTime(audioManager.recordingTime))
                                        .font(.medium(size: 12))
                                        .foregroundColor(Color(.secondary))
                                        .lineLimit(1)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.mainBlue)
                                        .frame(height: 1 + audioManager.waveformLevel * 60)
                                        .animation(.easeInOut(duration: 0.1), value: audioManager.waveformLevel)
                                }
                            }
                            
                            // Playback mode
                            if !audioManager.isRecording {
                                HStack(spacing: 0) {
                                    Button(action: {
                                        if audioManager.isPlaying {
                                            audioManager.pausePlayback()
                                        } else {
                                            audioManager.startPlayback()
                                        }
                                    }) {
                                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                            .foregroundColor(.mainBlue)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                    
                                    HStack {
                                        Text(audioManager.formatTime(audioManager.playbackTime))
                                            .font(.medium(size: 12))
                                            .foregroundColor(Color(.secondary))
                                            .lineLimit(1)
                                        
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(.btnDisabledBg))
                                                .frame(height: 4)
                                            
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.mainBlue)
                                                .frame(width: CGFloat(min(1, audioManager.playbackTime / max(0.1, audioManager.playbackDuration))) * 200, height: 4)
                                                .animation(.linear(duration: 0.1), value: audioManager.playbackTime)
                                        }
                                        .frame(width: 200)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            // Delete button
                            Button(action: {
                                audioManager.deleteRecording()
                                viewModel.recordingURL = nil
                            }) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 25, height: 28)
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing, 4)
                        }
                    } else {
                        // Text input
                        MessageInputField(comment: $viewModel.inputText, onSend: {
                            sendMessage()
                        })
                    }
                    
                    // Action button
                    if viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button(action: {
                            print("🔘 Button tapped - isRecording: \(audioManager.isRecording), recordingURL: \(audioManager.recordingURL != nil)")
                            
                            if audioManager.isRecording {
                                // Stop recording
                                print("🔴 Stopping recording...")
                                audioManager.stopRecording()
                                viewModel.recordingURL = audioManager.recordingURL
                            } else {
                                if audioManager.recordingURL != nil {
                                    // Send voice message
                                    print("📤 Sending voice message...")
                                    Task {
                                        await viewModel.createCustomerMessage()
                                        audioManager.deleteRecording()
                                    }
                                } else {
                                    // Start recording
                                    print("🔴 Starting recording...")
                                    audioManager.startRecording()
                                }
                            }
                        }) {
                            Image(systemName: audioManager.isRecording ? "stop.fill" : (audioManager.recordingURL == nil) ? "mic.fill" : "paperplane.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 38)
                                .horizontalGradientBackground()
                                .cornerRadius(7)
                        }
                    } else {
                        Button(action: {
                            sendMessage()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 38)
                                .horizontalGradientBackground()
                                .cornerRadius(7)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .frame(height: 110)
            .cardStyle(cornerRadius: 16)
        }
        .task {
            requestNotificationAuthorization()
            viewModel.CustomerPackageId = CustomerPackageId
            await viewModel.refresh()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task { await viewModel.refresh() }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.bg))
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading)
        .errorAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ),
            message: viewModel.errorMessage
        )
        .alert("Microphone Permission Required", isPresented: $audioManager.showPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Open Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("Please enable microphone access in Settings to record voice messages.")
        }
    }
    
    // MARK: - Helper Functions
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("[Notifications] Authorization error: \(error)")
            }
            print("[Notifications] Authorization granted: \(granted)")
        }
    }
    
    private func sendMessage() {
        let trimmed = viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        Task {
            await viewModel.createCustomerMessage()
        }
    }
}

#Preview {
    ChatsView(CustomerPackageId: 0)
}
