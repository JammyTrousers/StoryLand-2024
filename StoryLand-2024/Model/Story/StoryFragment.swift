//
//  StoryFragment.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import UIKit

struct StoryFragment {

    var content: String
    var tokenizedContent : [StoryWord] = [StoryWord]()
    
    //Legacy
    var readTokenizedWords : [String] = [String]()
    var tokenizedWords : [String] = [String]()
    
    /// check if this fragment is finished
    var isCompleted: Bool {
        for token in tokenizedContent {
            if token.readStatus == .unread {
                return false
            }
        }
        return true
    }

    var getReadTokenizedWords: Int {
        var count = 0
        for token in tokenizedContent {
            if token.readStatus == .read {
                count += 1
            }
        }
        return count
    }

    
    mutating func skip() {
        for i in 0..<tokenizedContent.count {
            if tokenizedContent[i].content.isPunctuation {
                tokenizedContent[i].readStatus = .read
            }
            
            if tokenizedContent[i].readStatus == .unread {
                tokenizedContent[i].readStatus = .skip
                break
            }
        }
    }
    
    /// Check if the input match with the StoryFragment's Content
    /// - Parameters:
    ///   - recognizedString: the recognized string by speech recognizer
    ///   - isAllowPartialCorrect: true - ok for partial correct, false - just match the first vocab
    mutating func check(recognizedString : String, allowPartialCorrect isAllowPartialCorrect : Bool = true) {
        for i in 0..<tokenizedContent.count {
            if tokenizedContent[i].readStatus == .unread {
                
                if tokenizedContent[i].content.isPunctuation {
                    tokenizedContent[i].readStatus = .read
                }
                
                if recognizedString.contains(tokenizedContent[i].content) ||
                    recognizedString.latinize()!.contains(tokenizedContent[i].content.latinize()!) == true
                {
                    tokenizedContent[i].readStatus = .read
                    //break
                } else if isAllowPartialCorrect == false {
                    break
                }
            }
        }

        guard let token = tokenizedWords.first else {
            return
        }
        if recognizedString.contains(token){
            tokenizedWords.removeFirst()
            readTokenizedWords.append(token)
        }

    }
    
    /// Break content into string array
    mutating func tokenize(){
        let str = self.content
        let ref = CFStringTokenizerCreate(nil, str as CFString, CFRangeMake(0, str.count), kCFStringTokenizerUnitWordBoundary, nil)
        CFStringTokenizerAdvanceToNextToken(ref)
        var range: CFRange
        range = CFStringTokenizerGetCurrentTokenRange(ref)
        
        // for-loop
        //var vocab = ""
        tokenizedWords.removeAll()
        tokenizedContent.removeAll()
        
        while range.length > 0{
            let startIndex = str.index(str.startIndex, offsetBy: range.location)
            let endIndex =  str.index(str.startIndex, offsetBy: range.location + range.length)
            //print(startIndex)
            
            let vocab = String(str[startIndex..<endIndex])
            tokenizedWords.append(vocab)
            
            let storyWord = StoryWord(content: vocab)
            print("\(vocab) - \(vocab.latinize()!)")
            tokenizedContent.append(storyWord)
            
            CFStringTokenizerAdvanceToNextToken(ref)
            range = CFStringTokenizerGetCurrentTokenRange(ref)
        }
        
    }
}

/// A Word of a vocab, the basic unit of a story
struct StoryWord {
    var content: String
    var readStatus: ReadStatus
    
    init(content:String, status: ReadStatus = .unread) {
        self.content = content
        self.readStatus = status
    }
    
    enum ReadStatus {
        case read
        case skip
        case unread
    }
}
