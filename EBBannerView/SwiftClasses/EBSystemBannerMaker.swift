//
//  EBSystemBannerMaker.swift
//  Pods-SwiftDemo
//
//  Created by pikacode on 2019/12/30.
//

import UIKit
import CoreFoundation
import AudioToolbox

public enum EBBannerSound {
    case none
    case name(_ name: String)
    case id(_ id: SystemSoundID)
    static var `default` = EBBannerSound.id(1312) // stytem sound `Tritone`
}

class EBSystemBannerMaker: NSObject {

    static var `default`: EBSystemBannerMaker = { return EBSystemBannerMaker() }()
    
    var banner: EBSystemBanner?
    
    var style: EBBannerStyle = {
        var i = (UIDevice.current.systemVersion as NSString).integerValue
        i = max(i, EBBannerStyle.allCases.first!.rawValue)
        i = min(i, EBBannerStyle.allCases.last!.rawValue)
        let s = EBBannerStyle(rawValue: i)
        return s!
    }()
    
    var icon: UIImage? = {
        var i: UIImage?
        for a in ["AppIcon40x40", "AppIcon60x60", "AppIcon80x80", "AppIcon"] {
            if let image = UIImage(named: a) {
                i = image
                break
            }
        }
        return i
    }()
    
    var appName: String? = {
        let d = Bundle.main.infoDictionary
        return d?["CFBundleDisplayName"] as? String ?? d?["CFBundleName"] as? String
    }()
    
    var title: String?
    var content: String?
    var date: String? = "now"//"现在"
    
    var showDuration: TimeInterval = 0.3
    var hideDuration: TimeInterval = 0.5
    var stayDuration: TimeInterval = 4
    var spreadStayDuration: TimeInterval = 4
    
    var object: Any?
    
    var sound: EBBannerSound = .default
    var vibrateOnMute = true
    var showDetailsOrHideWhenClickLongText = true
    
    var onClick = { (view: EBSystemBanner) in }
 
}
