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
    
    @ViewBuilder
    var hasQuiz: some View {
        if let question = story.question {
            NavigationLink(destination: QuizView(quiz: question)) {
                Label("Start Quiz", systemImage: "pencil.line")
                    .font(.title)
                    .bold()
            }
        } else {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Bye", systemImage: "pencil.line")
                    .font(.title)
                    .bold()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .bold()
                
                Text("You've completed \(story.name)🎉")
                    .font(.title3)
                
                hasQuiz
            }
        }
        .background(.ultraThinMaterial)
        .onAppear {
            withAnimation {
                animationsRunning.toggle()
            }
        }
    }
}

#Preview {
    StoryCompleteView(story: Story.defaultStory(title: .threelittlepigs), score: 1)
}
