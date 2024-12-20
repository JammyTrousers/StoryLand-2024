//
//  Shop.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation

struct Shop: Identifiable {
    var id = UUID()
    var itemName: String
    var price: Int
}

let shops = [
    Shop(itemName: "小鴨皮膚", price: 1),
    Shop(itemName: "小鴨皮膚", price: 1),
    Shop(itemName: "小鴨皮膚", price: 1)
]
