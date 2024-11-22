//
//  QuizCompleteView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct QuizCompleteView: View {
    @EnvironmentObject private var navigation: TodayNavigation
    
    var numStars: Int
    
    @State private var animationsRunning = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .bold()
                
                HStack(spacing: 40) {
                    Image(systemName: "star\(numStars >= 1 ? ".fill" : "")")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                    
                    Image(systemName: "star\(numStars >= 2 ? ".fill" : "")")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                    
                    Image(systemName: "star\(numStars >= 3 ? ".fill" : "")")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                }
                
                Button("Complete") {
                    navigation.showSheet = false
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation {
                animationsRunning.toggle()
            }
        }
    }
}

#Preview {
    QuizCompleteView(numStars: 3)
}
