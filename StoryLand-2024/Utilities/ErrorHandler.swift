//
//  ErrorHandler.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 23/11/2024.
//

import Foundation
import FirebaseFirestore

struct ErrorHandler {
    
    // TODO: Firestore error handler
    static func errorDatabase(error: Error?) -> String? {
        guard let error = error as NSError? else { return nil }
        switch FirestoreErrorCode.Code(rawValue: error.code) {
        case .invalidArgument: return ""
        case .deadlineExceeded: return ""
        case .notFound: return ""
        case .alreadyExists: return ""
        case .permissionDenied: return ""
        case .resourceExhausted: return ""
        case .failedPrecondition: return ""
        case .aborted: return ""
        case .outOfRange: return ""
        case .unimplemented: return ""
        case .internal: return ""
        case .unavailable: return ""
        case .dataLoss: return ""
        default: return error.localizedDescription
        }
    }

}
