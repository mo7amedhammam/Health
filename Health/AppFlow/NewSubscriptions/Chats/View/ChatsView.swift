//
//  ChatsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//

import SwiftUI
import AVFoundation

// MARK: - Single Bar View
struct WaveBarView: View {
    var height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.white)
            .frame(width: 2, height: max(height, 2))
    }
}

class WaveformViewModel: ObservableObject {
    @Published var levels: [CGFloat] = Array(repeating: 10, count: 15)
    private var timer: Timer?

    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            self?.levels = (0..<30).map { _ in CGFloat.random(in: 6...28) }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        levels = Array(repeating: 10, count: 15)
    }
}

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
//        .onAppear {
//            if isAnimating { viewModel.start() }
//        }
        .onChange(of: isAnimating) { newValue in
            newValue ? viewModel.start() : viewModel.stop()
        }
    }
}


// MARK: - MessageBubbleView
struct MessageBubbleView: View {
    let message: ChatsMessageM
    
    var body: some View {
//        let _ = print("🔍 message.comment = \(message.comment ?? "nil")")
//        let _ = print("✅ Final voicePath URL: \(Constants.baseURL + (message.voicePath ?? "").validateSlashs())")
        HStack {
            if message.isFromCustomer {
                Spacer()
            }
            
            HStack(alignment: .top) {
                
                if !message.isFromCustomer {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.white)
                        .frame(width: 34, height: 34)
                        .background(Color.mainBlue)
                        .clipShape(Circle())
                        .offset(y:14)
                }
                VStack(alignment:message.isFromCustomer ? .trailing:.leading, spacing: 4) {
                    Text(message.formattedDate)
                        .font(.regular(size: 12))
                        .foregroundColor(.gray)
                        .frame(height: 10)
                    
                    if message.voicePath == nil {
                        Text(message.messageText)
                            .font(.regular(size: 14))
                            .foregroundColor(message.isFromCustomer ? .white : .black)
                            .padding(12)
                            .background(message.isFromCustomer ? Color.mainBlue : Color(.messageSenderBg))
                            .cornerRadius(16)
                            .lineSpacing(8)
                    } else if let voice = message.voicePath,
                    let voiceURL = URL(string: Constants.baseURL + voice.validateSlashs()) {
                        
                     VoiceMessagePlayerView(voiceURL: voiceURL, isFromCustomer: message.isFromCustomer)
                            .localizeView()
                 }
                    
                }
                .frame(maxWidth: 280, alignment: message.isFromCustomer ? .trailing : .leading)
            }
            
            if !message.isFromCustomer {
                Spacer()
            }
        }
        //        .padding(.horizontal)
        .padding(.top, 4)

    }
}


//struct VoiceMessagePlayerView: View {
//    let voiceURL: URL
//    let isFromCustomer: Bool
//
//    @StateObject private var player = VoicePlayerManager()
//
//    var body: some View {
//        VStack(spacing: 8) {
//            HStack(spacing: 12) {
//                // 🔘 Play/Pause button
//                Button(action: {
//                    if player.isPlaying {
//                        player.pause()
//                    } else {
//                        player.play(from: voiceURL)
//                    }
//                }) {
//                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
//                        .foregroundColor(.white)
//                        .frame(width: 36, height: 36)
//                        .background(Circle().fill(Color.mainBlue))
//                }
//
//                // 📈 Simulated waveform (replace with real one later)
//                ZStack(alignment: .leading) {
//                    Capsule()
//                        .fill(Color.white.opacity(0.3))
//                        .frame(height: 4)
//                    Capsule()
//                        .fill(.white)
//                        .frame(width: CGFloat(player.progress) * 180, height: 4)
//                }
//                .animation(.easeInOut(duration: 0.2), value: player.progress)
//
//                // 🕐 Time
//                Text(player.formatTime(player.isPlaying ? player.currentTime : player.totalDuration))
//                    .font(.caption)
//                    .foregroundColor(.white)
//            }
//
//            // 🎚 Slider (optional for precise seeking)
//            Slider(value: Binding(get: {
//                player.progress
//            }, set: { newValue in
//                let newTime = newValue * player.totalDuration
//                player.seek(to: newTime)
//            }))
//            .accentColor(.white)
//        }
//        .padding()
//        .background(isFromCustomer ? Color.mainBlue : Color(.messageSenderBg))
//        .cornerRadius(16)
//    }
//}
struct VoiceMessagePlayerView: View {
    let voiceURL: URL
    let isFromCustomer: Bool

    @StateObject private var player = VoicePlayerManager()

    var body: some View {
        HStack(spacing: 8) {
            HStack {
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

//                Text(player.isPlaying ? "Playing...".localized : "Voice_message".localized)
//                    .font(.regular(size: 14))
//                    .foregroundColor(.white)
            }

//            if player.isPlaying {
                WaveformView(isAnimating: player.isPlaying)
//                     .frame(height: 40)
                     .padding(.vertical, 4)
//            }
            
//            // 🕐 Time
//            Text(player.formatTime(player.isPlaying ? player.currentTime : player.totalDuration))
//                .font(.caption)
//                .foregroundColor(.white)
            
        }
        .padding(12)
        .frame(height: 50)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(isFromCustomer ? Color.mainBlue : Color(.messageSenderBg))
        .cornerRadius(16)
    }
}
#Preview{
    VoiceMessagePlayerView(voiceURL: URL(string: "https://alnada-devsehatyapi.azurewebsites.net/Files/CustomerPackageMessage/302bf64e-dd4b-4f93-bcbd-85afd628b9bb.mp3")!, isFromCustomer: true)
}


// MARK: - ChatsView
struct ChatsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChatsViewModel.shared
    var CustomerPackageId : Int
    
//    let messages: [ChatsMessageM] = [
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Ask your question/ enquiry and you will get a reply here also, on your e-mail: ahmedsamer062@gmail.com",
//            sendByCustomer: false,
//            sendByDoctor: true,
//            voicePath: nil,
//            doctorID: 10,
//            creationDate: "2025-06-09T21:14:00Z"
//        ),
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Hello, I want to ask about shipment #1203489595A",
//            sendByCustomer: true,
//            sendByDoctor: false,
//            voicePath: nil,
//            doctorID: 10,
//            creationDate: "2025-06-09T21:14:00Z"
//        ),
//        ChatsMessageM(
//            customerPackageID: 1,
//            comment: "Yes of course, Ahmed... I will check that shipment for you right now. Oh! It’s a closed one... what about it?",
//            sendByCustomer: false,
//            sendByDoctor: true,
//            voicePath: nil,
//            doctorID: 10,
//            creationDate: "2025-06-09T21:14:00Z"
//        )
//    ]
    
//    @State private var inputText: String = ""
//    @State private var recordingURL: URL?
    
    @State private var isRecording: Bool = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordingTime: TimeInterval = 0
    @State private var recordingTimer: Timer?
    
    @State private var waveformLevel: CGFloat = 0
    @State private var levelTimer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var playbackTime: TimeInterval = 0
    @State private var isPlaying: Bool = false
    @State private var playbackTimer: Timer?
    
    init(CustomerPackageId:Int) {
        self.CustomerPackageId = CustomerPackageId
    }
    var body: some View {
        VStack(spacing: 0) {
            // Header placeholder
            HStack {
                Button(action:{
                    dismiss()
                }) {
                    Image(.backLeft)
                        .resizable()
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .frame(width: 31,height: 31)
                
                Spacer()
                
                VStack(alignment:.trailing,spacing: 5) {
                    (Text("د/") + Text("مي أحمد"))
                        .font(.bold(size: 20))
                        .foregroundColor(.mainBlue)
                    Text("Online".localized)
                        .font(.medium(size: 11))
                        .foregroundColor(Color(.secondary))
                }
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 49, height: 49)
                    .clipShape(Circle())
            }
            .padding()
            .background(Color.white)
            //            .shadow(radius: 2)
            
            // Messages
            MessagesListView(messages: viewModel.ChatMessages)
                .refreshable {
                    await viewModel.refresh()
                }
            
            // Input (non-functional)
            VStack() {
//                VoiceMessagePlayerView(voiceURL: URL(string: "https://alnada-devsehatyapi.azurewebsites.net/Files/CustomerPackageMessage/302bf64e-dd4b-4f93-bcbd-85afd628b9bb.mp3")!, isFromCustomer: true)

                HStack {
                    if let url = viewModel.recordingURL {
                        HStack(spacing: 12) {
                            // Recording duration + waveform
                            if isRecording {
                                HStack(spacing: 10) {
                                    Text(formatTime(recordingTime))
                                        .font(.medium(size: 12))
                                        .foregroundColor(Color(.secondary))
                                        .lineLimit(1)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.mainBlue)
                                        .frame( height: 1 + waveformLevel * 60)
                                        .animation(.easeInOut(duration: 0.1), value: waveformLevel)
                                }
                            }
                            
                            // Playback controls
                            if !isRecording {
                                HStack(spacing: 0) {
                                    Button(action: togglePlayback) {
                                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                            .foregroundColor(.mainBlue)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                    
                                    //                                    Spacer()
                                    
                                    HStack {
                                        Text(formatTime(playbackTime))
                                            .font(.medium(size: 12))
                                            .foregroundColor(Color(.secondary))
                                            .lineLimit(1)
                                        
                                        ZStack(alignment: .trailing) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color(.btnDisabledBg))
                                                .frame(height: 4)
                                                .frame(width: CGFloat(max(1, playbackTime / (audioPlayer?.duration ?? 1))) * 200)
                                            
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.mainBlue)
                                                .frame(height: 4)
                                                .frame(width: CGFloat(min(1, playbackTime / (audioPlayer?.duration ?? 1))) * 200)
                                                .animation(.linear(duration: 0.5), value: playbackTime)
                                        }
                                    }
                                    .frame(maxWidth:.infinity)
                                }
                            }
                            
                            // Delete button
                            Button(action: {
                                try? FileManager.default.removeItem(at: url)
                                viewModel.recordingURL = nil
                                stopRecording()
                                audioPlayer?.stop()
                                audioPlayer = nil
                                print("🗑 Voice message deleted")
                            }) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 25, height: 28)
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing,4)
                        }
                    }else{
                        MessageInputField(comment: $viewModel.inputText, onSend: {
                            sendMessage()
                        })
                    }
                    if viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button(action: {
                            if isRecording {
                                stopRecording()
                            } else {
                                if !(viewModel.recordingURL == nil) {
                                    //send voice
                                    Task{
                                        await viewModel.createCustomerMessage()
                                    }
                                }else{
                                    startRecording()
                                }
                            }
                        }) {
                            Image(systemName: isRecording ? "stop.fill" : (viewModel.recordingURL == nil) ? "mic.fill" : "paperplane.fill")
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
            //            .padding(.top,0)
            .background(Color.white)
            .frame(height: 110 )
            .cardStyle(cornerRadius: 16)
            
        }
        .task {
            viewModel.CustomerPackageId = CustomerPackageId
            await viewModel.refresh()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.bg))
//        .reversLocalizeView()
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
    }
    
    func startRecording() {
        let fileName = UUID().uuidString + ".m4a"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        viewModel.recordingURL = path
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
            startLevelTimer()
            recordingTime = 0
            startRecordingTimer()
            print("🎙 Started recording to: \(path.lastPathComponent)")
        } catch {
            print("❌ Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func startLevelTimer() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            audioRecorder?.updateMeters()
            let level = CGFloat(audioRecorder?.averagePower(forChannel: 0) ?? -60)
            waveformLevel = max(0, (level + 60) / 60) // Normalized to 0–1
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        levelTimer?.invalidate()
        recordingTimer?.invalidate()
        guard let url = viewModel.recordingURL else { return }
        print("✅ Voice recorded at: \(url.path)")
        
        // You can now upload or attach `url` as your voicePath
        levelTimer?.invalidate()
        waveformLevel = 0
    }
    
    func sendMessage() {
        let trimmed = viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        Task{
            await viewModel.createCustomerMessage()
        }
        print("📩 Sent message: \(trimmed)")
//        viewModel.inputText = ""
//        viewModel.recordingURL = nil

    }
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingTime += 1
        }
    }
    func togglePlayback() {
        guard let url = viewModel.recordingURL else { return }
        
        if isPlaying {
            audioPlayer?.pause()
            playbackTimer?.invalidate()
            isPlaying = false
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    //                    audioPlayer?.delegate = context.coordinator
                }
                audioPlayer?.play()
                isPlaying = true
                startPlaybackTimer()
            } catch {
                print("❌ Playback failed: \(error.localizedDescription)")
            }
        }
    }
    
    func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let player = audioPlayer {
                playbackTime = player.currentTime
                if !player.isPlaying {
                    isPlaying = false
                    playbackTimer?.invalidate()
                    playbackTime = 0
                }
            }
        }
    }
}

#Preview {
    ChatsView(CustomerPackageId: 0)
}


struct MessageInputField: View {
    @Binding var comment: String
    let onSend: () -> Void
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TextField("Write_a_message".localized, text: $comment, axis: .vertical)
                .font(.medium(size: 14))
                .padding(.horizontal)
                .frame(minHeight: 40)
                .background(Color(.messageSenderBg).cornerRadius(7))
                .onSubmit {
                    onSend()
                }
        } else {
            MultilineTextField("Write_a_message".localized, text: $comment, onCommit: onSend)
                .frame(minHeight: 40)
                .background(Color(.messageSenderBg).cornerRadius(7))
        }
    }
}

struct EmptyMessageBox: View {
    var body: some View {
        VStack{
            Spacer()
//            Image("messagebox")
            Image("chats")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(30)
                .frame(width: 162, height: 162)
                .background(Color(.bgPurple).clipShape(Circle()))
                .foregroundColor(Color(.btnDisabledTxt))

            Text("Message box is empty".localized())
                .font(.semiBold(size:22))
                .foregroundColor(Color(.btnDisabledTxt))
                .padding()
            Spacer()
            
        }
    }
}



struct MessagesListView: View {
    var messages: [ChatsMessageM]?
    
    var body: some View {
//        if let messages = messages, messages.count > 0 {
//            List {
//                VStack(spacing: 0) {
//                    ForEach(messages) { message in
//                        MessageBubbleView(message: message)
//                    }
//                }
//                .padding(.top, 8)
//                .listRowSpacing(0)
//                .listRowSeparator(.hidden)
//                .listRowBackground(Color.clear)
//                
//            }
//            .listStyle(.plain)
//        } else {
        
        if let messages = messages, messages.count > 0 {
            ScrollViewReader { proxy in
                List {
                    ForEach(messages.indices, id: \.self) { index in
                        MessageBubbleView(message: messages[index])
                            .id(index) // ✅ Assign unique ID for scroll target
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .onChange(of: messages.count) { _ in
                    // ✅ Scroll to last message when messages update
                    withAnimation {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
                .onAppear {
                    if !messages.isEmpty {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            
            } else {
//            ScrollView{
                EmptyMessageBox()
                    .frame(maxHeight:.infinity, alignment: .center)
//            }
        }
       
    }
}
