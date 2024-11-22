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
    
    func documentStoryRead(completion: CompletionHandler) {
        storyRef.getDocuments { documentSnapshot, error in
            if let error = error as NSError? {
                // Initialize FirestoreErrorCode.Code with the error code
                if let errorCode = FirestoreErrorCode.Code(rawValue: error.code) {
                    let errorMessage: String
                    
                    switch errorCode {
                    case .notFound:
                        errorMessage = "The requested document or collection was not found."
                    case .permissionDenied:
                        errorMessage = "You do not have permission to perform this action."
                    case .unavailable:
                        errorMessage = "The service is currently unavailable. Please try again later."
                    case .resourceExhausted:
                        errorMessage = "Resource limit reached. Try reducing load or wait before retrying."
                    default:
                        errorMessage = error.localizedDescription
                    }
                    
                    completion?(errorMessage)
                } else {
                    // Handle cases where the error code does not map to FirestoreErrorCode.Code
                    completion?(error.localizedDescription)
                }
                return
            }
            
            guard let documents = documentSnapshot?.documents else {
                completion?("No data was found in the requested collection.")
                return
            }
            
            Story.list = documents.compactMap { queryDocumentSnapshot -> Story? in
                return try? queryDocumentSnapshot.data(as: Story.self)
            }
            completion?(nil)
        }
    }
}
