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
    
    private var shopRef: CollectionReference {
        db.collection("shopItems")
    }
    
    func documentStoryAddListener(completion: @escaping ([Story]) -> Void) -> ListenerRegistration {
        return storyRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let stories = documents.compactMap { queryDocumentSnapshot -> Story? in
                return try? queryDocumentSnapshot.data(as: Story.self)
            }
            completion(stories)
        }
    }
    
    func documentShopAddListener(completion: @escaping ([Shop]) -> Void) -> ListenerRegistration {
        return shopRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            let shops = documents.compactMap { queryDocumentSnapshot -> Shop? in
                return try? queryDocumentSnapshot.data(as: Shop.self)
            }
            
            print("got shops: \(shops.count)")
            
            completion(shops)
        }
    }
}
