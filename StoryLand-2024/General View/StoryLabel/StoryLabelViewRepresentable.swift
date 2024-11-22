//
//  StoryLabelViewRepresentable.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct StoryLabelViewRepresentable: UIViewRepresentable {
    
    @Binding var storyTellingCoordinator: StoryTellingController?
    @Binding var storyFragment: StoryFragment?
    
    func makeUIView(context: Context) -> StoryLabel {
        let view = StoryLabel()
        view.delegate = self
        return view
    }
    
    func updateUIView(_ uiView: StoryLabel, context: Context) {
        uiView.storyFragment = storyFragment
    }

}

extension StoryLabelViewRepresentable: StoryLabelDelegate {
    
    func labelDidSelectedLinkText(label: StoryLabel, text: String) {
        self.storyTellingCoordinator?.speak(word: text)
    }
    
}
