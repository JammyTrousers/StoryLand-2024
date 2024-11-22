//
//  NSAttributedString+StoryWord.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func make(with storyFragment : StoryFragment) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: storyFragment.content)
        var index = 0
        
        for i in 0..<storyFragment.tokenizedContent.count {
            let storyWord = storyFragment.tokenizedContent[i]
            
            var color : UIColor
            switch storyWord.readStatus {
            case .read:
                color = StoryLabel.readTextColour
            case .skip:
                color = StoryLabel.skipTextColour
            case .unread:
                color = StoryLabel.unreadTextColour
            }
            
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSMakeRange(index, storyWord.content.count))
            index += storyWord.content.count
        }
        
        attributedString.addAttributes([NSAttributedString.Key.kern : 8], range: NSMakeRange(0, storyFragment.content.count))
        
        return attributedString
    }
}
