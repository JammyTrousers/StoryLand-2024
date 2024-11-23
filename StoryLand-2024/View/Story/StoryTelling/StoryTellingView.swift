//
//  StoryTellingView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI
import Speech

struct StoryTellingView: View {
    @EnvironmentObject private var navigation: TodayNavigation
    
    @State var storyFragment: StoryFragment? = nil
    @State var storyTellingCoordinator: StoryTellingController?
    
    @State var storyLabel = StoryLabel()
    @State var gifImage: String
    @State private var storybackgroundImage: String = "Artboard 53"
    @State private var progress: Float = 0
    
    @State var score: Int = 0
    @State var counters: Int = 0            // total words
    @State var correctCount: Int = 0        // read words
    
    @State private var statusMessage: String? = nil
    @State private var isAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isDisableSkipButton: Bool = false
    @State var isDisableListenButton: Bool = false
    
    @State var story: Story
    
    var title: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            
            Spacer()
            
            HStack {
                Label("Estimated Reading Time", systemImage: "clock")
                Text("3 mins")
                    .foregroundStyle(Color.seaBlue)
            }
        }
        .padding(.all, 24)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
        .overlay {
            Text(story.name)
                .foregroundStyle(Color.seaBlue)
                .font(.title)
                .bold()
        }
    }
    
    var instruction: some View {
        HStack {
            Image("Character_Side_Large_123_175")
            
            Text("If you don't know how to pronounce a word, press that word, or press 'Pronounce' to hear the whole sentence.")
                .font(.title3)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
    
    var content: some View {
        VStack {
            StoryLabelViewRepresentable(storyTellingCoordinator: $storyTellingCoordinator, storyFragment: $storyFragment)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    var alertFailPermission: Alert {
        Alert(
            title: Text("This application requires a voice service to work."),
            message: Text("Please consider changing your settings."),
            primaryButton: .destructive(Text("Open Settings"), action: {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url)
            }),
            secondaryButton: .default(Text("Cancel"))
        )
    }
    
    var buttons: some View {
        HStack {
            Button {
                // Use the fragment content as a fallback if storyLabel.text is empty
                let textToSpeak = storyLabel.text?.isEmpty ?? true ? storyFragment?.content ?? "No content available" : storyLabel.text!
                
                print("Text to speak: \(textToSpeak)") // Debugging
                StoryTellingAssistant.shared.speak(word: textToSpeak)
            } label: {
                Label("Listen", systemImage: "speaker.wave.3.fill")
            }
            .buttonStyle(.filled)
            .frame(maxWidth: .infinity)
            .disabled(isDisableListenButton)
            
            Button(action: {
                self.storyTellingCoordinator?.skip()
            }, label: {
                Label("Skip", systemImage: "chevron.right")
            })
            .buttonStyle(.filled)
            .frame(maxWidth: .infinity)
            .disabled(isDisableSkipButton)
        }
    }
    
    var body: some View {
        ZStack {
            Image(storybackgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                title
                
                GeometryReader { proxy in
                    VStack(alignment: .center, spacing: 20) {
                        GIFViewRepresentable(gifName: $gifImage)
                            .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.8)
                        
                        VStack {
                            ZStack(alignment: .bottom) {
                                content

                                ProgressView("\(Int(progress * 100))%", value: progress, total: 1)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .frame(height: proxy.size.height * 0.2)
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    instruction
                    
                    buttons
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $navigation.showSheet) {
            StoryCompleteView(story: story, score: score)
        }
        .alert(isPresented: $isAlert) {
            alertFailPermission
        }
        .onAppear {
            checkPermissions()
            
            self.story.setup()
            
            self.storyTellingCoordinator = StoryTellingController(story: self.story)
            self.storyTellingCoordinator?.delegate = self
            
            self.storyTellingCoordinator?.startStoryTelling()
            
            updateContent()
        }
        .onDisappear {
            storyTellingCoordinator?.stopStoryTelling()
            storyTellingCoordinator = nil
        }
    }
    
    private func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization{
            authStatus in DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                case .denied: isAlert = true
                default: statusMessage = "無法存取語音"
                }
            }
        }
    }
    
    func completeStory() {
        progress = 1
        
        isDisableSkipButton = true
        isDisableListenButton = true

        self.storyTellingCoordinator?.stopStoryTelling()
        let result = Double(correctCount) / Double(counters)
        
        navigation.showSheet = true
        
        score = Int(result)
    }
    
    func updateContent() {
        guard let storyTellingCoordinator = self.storyTellingCoordinator else { return }
        
        let stage = storyTellingCoordinator.story.pointer
        print("stage: \(stage)")
        
        let fragmentCount = storyTellingCoordinator.story.contents.count
        
        if (stage >= fragmentCount) {
            completeStory()
        }
        
        if (stage < fragmentCount) {
            self.storyFragment = self.storyTellingCoordinator?.story.currentFragment
            progress = Float(Double(stage) / Double(fragmentCount - 1))
            
            // Update storyLabel.text with the fragment content
            storyLabel.text = self.storyFragment?.content ?? ""
        }
        
        switch stage {
        case 0...2: gifImage = "s1"; break
        case 3...4: gifImage = "s2"; break
        case 5: gifImage = "s3"; break
        case 6...7: gifImage = "s4"; break
        case 8...10: gifImage = "s5"; break
        case 11...12: gifImage = "s6"; break
        case 13: gifImage = "s7"; break
        case 14...15: gifImage = "s8"; break
        case 16: gifImage = "s9"; break
        case 17...18: gifImage = "s10"; break
        case 19: gifImage = "s11"; break
        default: break
        }
        
        if (stage >= 8 && stage < fragmentCount) { storybackgroundImage = "nai" }
    }
    
}

#Preview {
    return StoryTellingView(gifImage: "s1", story: Story.defaultStory(title: .threelittlepigs))
}
