//
//  StoryTeller.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation

struct StoryTeller {
    static var shared: StoryTeller = StoryTeller()
    
    var lang: String = "zh-hk"
    
    var locale: Locale { Locale(identifier: self.lang) }
}
