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
    
    func doucmentStoryRead(completion: CompletionHandler) {
        storyRef.getDocuments { documentSnapshot, error in
            guard error == nil else { completion?(ErrorHandler.errorDatabase(error: error)); return }
            guard let documents = documentSnapshot?.documents else { completion?(ErrorHandler.errorDatabase(error: error)); return }
            Story.list = documents.compactMap { (queryDocumentSnapshot) -> Story? in
                return try? queryDocumentSnapshot.data(as: Story.self)
            }
            completion?(nil)
        }
    }
}
