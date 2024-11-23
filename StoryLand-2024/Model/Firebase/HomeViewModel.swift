//
//  HomeViewModel.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 24/11/2024.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var stories: [Story] = []
        @Published var isLoading: Bool = true

        private var listenerRegistration: ListenerRegistration?

        init() {
            loadStories()
        }

        deinit {
            listenerRegistration?.remove()
        }

        private func loadStories() {
            listenerRegistration = Database.shared.documentStoryAddListener { stories in
                DispatchQueue.main.async {
                    self.stories = stories
                    self.isLoading = false
                }
            }
        }
}
