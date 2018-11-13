//
//  AudioManager.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class AudioManager {
    
    var audioPlayer : AVAudioPlayer! = nil
    var error : NSError? = nil
    
    class var sharedInstance: AudioManager {
        struct Static {
            static var instance: AudioManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = AudioManager()
        }
        return Static.instance!
    }
    
    func playAudio(fileName: String, fileType: String, loop: Int){
        
        var initError: NSError?
        
        
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType),
            let filePathURL = NSURL.fileURLWithPath(filePath) {
                
                if let audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL, error: &initError) {
                    if audioPlayer.prepareToPlay() {
                        audioPlayer.play()
                        audioPlayer.numberOfLoops = loop
                    }
                } else {
                    println("Failed to load the sound: \(initError)")
                }
        }else{
            println("the filePath is empty OR the file did not load")
        }
    }
    
    func playAudio(sound: KYSound){
        var fileName = sound.name
        var fileType = sound.type
        var loop = sound.loop
        playAudio(fileName, fileType: fileType, loop: loop)
    }
    
    func playBeepSound(){
        playAudio(soundBeep)
    }
    
    func stopAudio(){
        audioPlayer.stop()
    }
}
