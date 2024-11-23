//
//  StorySelectionView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct StorySelectionView: View {
    
    var stories = [Story]()
    
    private let itemWidth: CGFloat = 550.0
    
    @State private var stored: Int = 0
    
    private func scrollView() -> some View {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.stories) { story in
                            NavigationLink {
                                StoryTellingView(gifImage: story.coverImage, story: story)
                            } label: {
                                StoryGridCell(story: story)
                                    .frame(minHeight: proxy.size.height)
                            }
                        }
                    }
                    .padding(.horizontal, (proxy.size.width - itemWidth)/2)
                }
            }
        }
    
    var body: some View {
        NavigationStack {
            scrollView()
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Choose your story")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
        .background {
            Image("Background")
        }
    }
}
