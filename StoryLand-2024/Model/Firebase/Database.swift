//
//  Database.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 22/11/2024.
//

import Foundation
import FirebaseFirestore

class Database {
    typealias CompletionHandler = ((String?) -> Void)?
    
    static let shared = Database()
    
    private let db = Firestore.firestore()
    
    private var storyRef: CollectionReference {
        db.collection("stories")
    }
    
    func fetchStories(completion: CompletionHandler) {
        storyRef.getDocuments { documentSnapshot, error in
            if let error = error {
                completion?("Error fetching stories: \(error.localizedDescription)")
                return
            }
    
            guard let documents = documentSnapshot?.documents else {
                completion?("No stories found.")
                return
            }
            
            do {
                Story.list = try documents.compactMap { queryDocumentSnapshot in
                    try queryDocumentSnapshot.data(as: Story.self)
                }
                completion?(nil) // Success
            } catch {
                completion?("Failed to parse stories: \(error.localizedDescription)")
            }
        }
    }
}
