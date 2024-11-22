//
//  Category.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation

struct Category: Identifiable {
    var id = UUID()
    var name: String
    var stories = [Story]()
}

let categories = [
    Category(name: "1", stories: stories),
    Category(name: "2"),
    Category(name: "3"),
    Category(name: "4")
]
