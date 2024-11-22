//
//  StoryTellingController.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import AVFoundation

protocol StoryTelling {
    func storyProgressUpdate(storyFragment: StoryFragment)
    func storyFragmentUpdated()
    func storyAssistStartSpeaking()
    func storyAssistFinishSpeaking()
}

/// The Game Logic
class StoryTellingController: NSObject {
    var story: Story
    
    var delegate: StoryTelling?
    
    //TODO
    var storyTellingRecognizer = StoryTellingRecognizer(locale: StoryTeller.shared.locale, partialResults: false)
    var storyTellingAssistant = StoryTellingAssistant.shared
    
    init(story: Story) {
        self.story = story
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReecived(_:)), name: .recognizedString, object: nil)
        self.storyTellingAssistant.speechSynthesizer.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .recognizedString, object: nil)
    }
    
    func startStoryTelling(){
        storyTellingRecognizer?.startRecognize()
    }
    
    func stopStoryTelling() {
        storyTellingRecognizer?.stopRecognize()
    }
    
    func next() {
        self.story.pointer += 1
        self.delegate?.storyFragmentUpdated()
    }
    
    func skip() {
        self.story.skip()
        self.delegate?.storyProgressUpdate(storyFragment: self.story.currentFragment)
    }
    
    /// Speak the content of the entire fragment
    func speakFragment() {
        self.storyTellingAssistant.speak(word: story.currentFragment.content)
    }
    
    /// Speak with designated word
    func speak(word : String) {
        self.storyTellingAssistant.speak(word: word)
    }
    
    var supportsOnDeviceRecognition : Bool {
        guard let storyTellingRecognizer = self.storyTellingRecognizer else { return false }
        return storyTellingRecognizer.supportsOnDeviceRecognition
    }
    
    @objc func notificationReecived(_ notification: Notification) {
        guard let text = notification.userInfo?["text"] as? String else { return }
        self.story.check(recognizedString: text)
        self.delegate?.storyProgressUpdate(storyFragment: self.story.currentFragment)
    }
}

//MARK: - Process of the Story / StoryFragment
extension StoryTellingController {
    var isCurrentFragmentCompleted : Bool { return self.story.currentFragment.isCompleted }
    var totalWords: Int { return self.story.currentFragment.tokenizedContent.count }
    var correctWords: Int { return self.story.currentFragment.getReadTokenizedWords }
    var isStoryCompleted: Bool { return false }
}

//MARK: - AVSpeechSynthesizer Delegate
extension StoryTellingController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Start Speaking with Assistant")
        self.storyTellingRecognizer?.stopRecognize()
        self.delegate?.storyAssistStartSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Finish")
        self.storyTellingRecognizer?.startRecognize()
        self.delegate?.storyAssistFinishSpeaking()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //        print(characterRange.location, "-----", characterRange.length)
        let subStr = utterance.speechString.dropFirst(characterRange.location).description
        let rangeStr = subStr.dropLast(subStr.count - characterRange.length).description
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.delegate?.storyAssistFinishSpeaking()
    }
    
}
