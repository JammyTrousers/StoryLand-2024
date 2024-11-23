//
//  StoryCompleteView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

class TodayNavigation: ObservableObject {
    @Published var showSheet = false
}

struct StoryCompleteView: View {
    var story: Story
    var score: Int
    
    @State private var animationsRunning = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .bold()
                
                Text("You've completed \(story.name)🎉")
                    .font(.title3)
                
                Text("You got 2 tokens ⭐️")
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Done")
                })
                .buttonStyle(.filled)
                .frame(maxWidth: .infinity)
            }
        }
        .background(.ultraThinMaterial)
        .onAppear {
            withAnimation {
                animationsRunning.toggle()
            }
            
            DataManager.shared.addToken(token: 2)
        }
    }
}

#Preview {
    StoryCompleteView(story: Story.defaultStory(title: .threelittlepigs), score: 1)
}
