//
//  EBEmptyWindow.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2020/1/2.
//

import UIKit

class EBEmptyWindow: UIWindow {
    
    static let shared: EBEmptyWindow = {
        let window = EBEmptyWindow(frame: .zero)
        window.windowLevel = .alert
        return window
    }()
    
}
