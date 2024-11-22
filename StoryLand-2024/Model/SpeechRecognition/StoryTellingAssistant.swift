//
//  StoryTellingAssistant.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import AVFoundation

/// Speak the words for the user
struct StoryTellingAssistant {

    static let shared = StoryTellingAssistant(lang: StoryTeller.shared.lang)
    let speechSynthesizer = AVSpeechSynthesizer()
    
    private let lang: String

    func speak(word: String) {
        let voice = AVSpeechSynthesisVoice(language: StoryTeller.shared.lang)
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = (AVSpeechUtteranceMinimumSpeechRate * 0.2 + AVSpeechUtteranceDefaultSpeechRate * 0.8)
        utterance.voice = voice
        utterance.volume = 1
        utterance.pitchMultiplier = 1.0
        //开始播放
        StoryTellingAssistant.shared.speechSynthesizer.speak(utterance)
    }
}
