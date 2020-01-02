//
//  EBCustomBannerMaker.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2020/1/2.
//

import UIKit

class EBCustomBannerMaker: NSObject {

    var portraitFrame = CGRect.zero
    var landscapeFrame = CGRect.zero
    var soundID = EBBannerSound.default
    var animationDuration: TimeInterval = 0.3
    var stayDuration: TimeInterval = 4.0//set <=0 will not hide
    var portraitStyle = EBCustomBanner.TransitionStyle.top
    var landscapeStyle = EBCustomBanner.TransitionStyle.top
    var vibrateOnMute = true
    
}

