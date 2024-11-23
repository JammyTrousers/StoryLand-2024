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
    @Published var shops: [Shop] = []
    @Published var isLoading: Bool = true

    private var listenerRegistration: ListenerRegistration?

    init() {
        loadStories()
        loadShops()
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
    
    private func loadShops() {
        listenerRegistration = Database.shared.documentShopAddListener { shops in
            DispatchQueue.main.async {
                self.shops = shops
                self.isLoading = false
            }
        }
    }
}
