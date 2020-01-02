//
//  EBMuteDetector.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2019/12/31.
//

import UIKit
import AudioToolbox

class EBMuteDetector: NSObject {
    
    static let shared: EBMuteDetector = {
        let url = Bundle(for: EBMuteDetector.self).url(forResource: "EBMuteDetector", withExtension: "mp3")! as CFURL
        var detector = EBMuteDetector()
        let status = AudioServicesCreateSystemSoundID(url, &detector.soundID)
        if status == kAudioServicesNoError {
            AudioServicesAddSystemSoundCompletion(detector.soundID, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue, completionProc, Unmanaged.passUnretained(detector).toOpaque())
            var yes = 1
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, UInt32(MemoryLayout<SystemSoundID>.size), &detector.soundID, UInt32(MemoryLayout<Bool>.size), &yes)
        } else {
            detector.soundID = .max
        }
        return detector
    }()

    static let completionProc: AudioServicesSystemSoundCompletionProc = {(soundID: SystemSoundID, p: UnsafeMutableRawPointer?) in
        let elapsed = Date.timeIntervalSinceReferenceDate - shared.interval
        let isMute = elapsed < 0.1
        shared.completion(isMute)
    }
    
    var completion = { (mute: Bool) in }
 
    var soundID: SystemSoundID = 1312
    
    var interval: TimeInterval = 1
    
    func detect(block: @escaping (Bool) -> ()) {
        interval = NSDate.timeIntervalSinceReferenceDate
        AudioServicesPlaySystemSound(soundID)
        completion = block
    }
    
    deinit {
        if (soundID != .max) {
            AudioServicesRemoveSystemSoundCompletion(soundID);
            AudioServicesDisposeSystemSoundID(soundID);
        }
    }

}
  
