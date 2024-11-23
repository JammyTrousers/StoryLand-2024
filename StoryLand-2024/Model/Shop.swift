//
//  Shop.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import FirebaseFirestore

struct Shop: Identifiable, Codable {
    @DocumentID var id: String?
    var itemName: String
    var price: String
    
    init(itemName: String, price: String) {
        self.itemName = itemName
        self.price = price
    }
}
