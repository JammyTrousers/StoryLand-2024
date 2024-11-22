//
//  StoryTellingView+StoryTelling.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

extension StoryTellingView: StoryTelling {
    
    func storyProgressUpdate(storyFragment: StoryFragment) {
        print("readTokenizedWords: \(storyFragment.readTokenizedWords)")
        
        self.storyLabel.storyFragment = storyFragment
        
        if self.storyTellingCoordinator?.isCurrentFragmentCompleted == true {
            self.counters += (self.storyTellingCoordinator != nil) ? self.storyTellingCoordinator!.totalWords : 0
            self.correctCount += (self.storyTellingCoordinator != nil) ? self.storyTellingCoordinator!.correctWords : 0
            
            if self.storyTellingCoordinator?.supportsOnDeviceRecognition == true {
            
                //handle on device mode
                
            }  else {
                
                //handle not on device mode
                
            }
            
            self.storyTellingCoordinator?.stopStoryTelling()
            self.storyTellingCoordinator?.next()
            self.storyTellingCoordinator?.startStoryTelling()
        }
        
    }
    
    func storyFragmentUpdated() {
        DispatchQueue.main.async {
            self.updateContent()
        }
    }
    
    func storyAssistStartSpeaking() {
        //self.setHearAudioSession()
        self.storyLabel.isUserInteractionEnabled = false
    }
    
    func storyAssistFinishSpeaking() {
        self.storyLabel.isUserInteractionEnabled = true
        self.storyLabel.removeHighlight()
        //self.setReadAudioSession()
    }
    
}
