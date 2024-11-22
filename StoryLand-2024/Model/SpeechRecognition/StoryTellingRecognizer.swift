//
//  StoryTellingRecognizer.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import Foundation
import AVFoundation
import Speech

class StoryTellingRecognizer {

    var recognizer: SFSpeechRecognizer
    
    var identifier = 0
    
    var request: SFSpeechAudioBufferRecognitionRequest
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    public init?(locale: Locale, partialResults: Bool = true) {
        guard let recognizer = SFSpeechRecognizer(locale : locale) else { print("no locale"); return nil }
        
        guard recognizer.isAvailable == true else { print("not available"); return nil }
        
        guard recognizer.supportsOnDeviceRecognition else { print("no on device"); return nil }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = partialResults
        request.requiresOnDeviceRecognition = true
        
        self.recognizer = recognizer
    }
    
    func makeRequest(partialResults : Bool = true) {
        request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = partialResults
        request.requiresOnDeviceRecognition = true
    }
    
    var supportsOnDeviceRecognition: Bool {
        return recognizer.supportsOnDeviceRecognition
    }
    
    func startRecognize() {
        makeRequest(partialResults: true)
        
        var newIdentifier = 0
        repeat {
            newIdentifier = Int(arc4random_uniform(50000))
        } while newIdentifier == identifier
        
        self.identifier = newIdentifier

        //setup audio engine and speech recognizer
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in
            self.request.append(buffer)
        }
        
        //prepare and start recording
        audioEngine.prepare()
        do { try audioEngine.start() }
        catch { return print(error) }
        
        //Analyze the speech
        recognitionTask = self.recognizer.recognitionTask(with:  request, resultHandler: {
            result, error in
            
            let localIdentifier = newIdentifier
            
            if let result = result {
                guard localIdentifier == self.identifier else {
                    print("unused closure: \(localIdentifier) \(self.identifier)")
                    return
                }
                
                print("Score: \(result.bestTranscription.segments.first?.confidence)")
       
                let userInfo = ["text": result.bestTranscription.formattedString]
                print(result.bestTranscription.formattedString)
                NotificationCenter.default.post(name: .recognizedString, object: nil, userInfo: userInfo)
                
                if result.isFinal {
                    // print("=== isFinal")
                }
                
                /*
                if result.isFinal {
                    //ImmersiveCore.printer?.debugPrint(msg: "\(result.bestTranscription.formattedString) - Final")
                    //print("\(result.bestTranscription.formattedString) - Final")
                } else {
                    //ImmersiveCore.printer?.debugPrint(msg: result.bestTranscription.formattedString)
                    //print("\(result.bestTranscription.formattedString)")
                }
                */
 
            } else if let error = error {
                print(error)
            }
        })
    }
    
//    var isRecognizing : Bool {
//        recognitionTask.is
//    }
    
    func stopRecognize() {
        audioEngine.stop()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionTask?.finish()
    }
    
    func grantPermission() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized { return }
        SFSpeechRecognizer.requestAuthorization{
            status in
            switch status {
            case .authorized:
                print("authorized")
            default:
                print("unavailable")
            }
        }
    }
}
