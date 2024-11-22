//
//  String+ToLatin.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation

extension String {
    var toLatin: String {
        get {
            let mutableString = NSMutableString(string: self)
            CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
            return mutableString as String
        }
    }
}
