//
//  String+Latinize.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation

extension String {
    /// return latinized character (for chinese use)
    public func latinize() -> String? {
        //return self.applyingTransform(.mandarinToLatin, reverse: false)?.applyingTransform(.stripCombiningMarks, reverse: false)
        return self.applyingTransform(.toLatin, reverse: false)?.applyingTransform(.stripCombiningMarks, reverse: false)
    }
    
    public var isPunctuation : Bool {
        let characterSet = CharacterSet(charactersIn: ",./;'\"!，?、《》「」。！？ ")
        if self.rangeOfCharacter(from: characterSet) != nil {
            //print("is punctuation")
            return true
        }
        return false
    }
}
