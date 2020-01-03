//
//  EBCustomBanner.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2020/1/2.
//

import UIKit
import AudioToolbox

class EBCustomBanner: NSObject {
    
    static var sharedBanners = [EBCustomBanner]()
    static let sharedWindow = EBBannerWindow.shared

    enum TransitionStyle {
        case top, left, right, bottom
        case center(durations: (alpha: TimeInterval, max: TimeInterval, final: TimeInterval) = (0.3, 0.2, 0.1))
    }
    
    init(view: UIView) {
        self.view = view
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarOrientation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    ///make a custom view and show immediately,
    @discardableResult
    static func show(_ view: UIView) -> EBCustomBanner { return EBCustomBanner(view: view).show() }
    
    @discardableResult
    func show() -> EBCustomBanner {
        
        EBCustomBanner.sharedBanners.append(self)

        var soundID: SystemSoundID = 0
        switch maker.soundID {
        case .none:
            break
        case .name(let name):
            guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { break }
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        case .id(let id):
            soundID = id
        }

        EBMuteDetector.shared.detect { (isMute) in
            if isMute && self.maker.vibrateOnMute {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            } else {
                AudioServicesPlaySystemSound(soundID)
            }
        }

        EBCustomBanner.sharedWindow.rootViewController?.view.addSubview(view)
        
        switch currentStyle {
        case .center(durations: let durations):
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.view.frame = weakSelf.showFrame
                weakSelf.view.alpha = 0
                UIView.animate(withDuration: durations.alpha, animations: {
                    weakSelf.view.alpha = 1
                })
                weakSelf.view.alpha = 0
                weakSelf.view.layer.shouldRasterize = true
                weakSelf.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                UIView.animate(withDuration: durations.max, animations: {
                    weakSelf.view.alpha = 1
                    weakSelf.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                }) { _ in
                    UIView.animate(withDuration: durations.final, animations: {
                        weakSelf.view.alpha = 1
                        weakSelf.view.transform = CGAffineTransform.identity
                    }) { _ in
                        weakSelf.view.layer.shouldRasterize = false
                        if weakSelf.maker.stayDuration > 0 {
                            Timer.scheduledTimer(timeInterval: weakSelf.maker.stayDuration, target: weakSelf, selector: #selector(weakSelf.hide), userInfo: nil, repeats: false)
                        }
                    }
                }
            }
        default:
            view.frame = hideFrame
            UIView.animate(withDuration: maker.animationDuration, animations: {
                self.view.frame = self.showFrame
            }) { (finish) in
                if self.maker.stayDuration > 0 {
                    Timer.scheduledTimer(timeInterval: self.maker.stayDuration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
                }
            }
        }
        return self
    }
      
    @objc func hide() {

        if view.superview == nil {
            return
        }
         
        switch currentStyle {
        case .center(durations: let durations):
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: durations.alpha) {
                    self?.view.alpha = 0
                }
                
                self?.view.layer.shouldRasterize = true
                
                UIView.animate(withDuration: durations.max, animations: {
                    self?.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { (finish) in
                    UIView.animate(withDuration: durations.final, animations: {
                        self?.view.alpha = 0
                        self?.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    }) { (finish) in
                        self?.view.removeFromSuperview()
                        guard let weakSelf = self else { return }
                        guard let index = EBCustomBanner.sharedBanners.firstIndex(of: weakSelf) else { return }
                        EBCustomBanner.sharedBanners.remove(at: index)
                    }
                }
            }
        default:
            UIView.animate(withDuration: maker.animationDuration, animations: {
                self.view.frame = self.hideFrame
            }) { (finish) in
                self.view.removeFromSuperview()
                EBCustomBanner.sharedBanners.removeAll { $0 == self }
            }
        }
      
    }
    
    
    private var view: UIView
    private let maker = EBCustomBannerMaker()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension EBCustomBanner {
    
    var currentIsLandscape: Bool { return UIDevice.current.orientation.isLandscape }
    
    var showFrame: CGRect { return currentIsLandscape ? maker.landscapeFrame : maker.portraitFrame }
    
    var currentStyle: TransitionStyle { return currentIsLandscape ? maker.landscapeStyle : maker.portraitStyle }
     
    var hideFrame: CGRect {
        var hideFrame = showFrame
        let screenSize = UIScreen.main.bounds.size
        switch currentStyle {
        case .top:
            hideFrame.origin.y = -hideFrame.size.height
        case .left:
            hideFrame.origin.x = -hideFrame.size.width
        case .right:
            hideFrame.origin.x = screenSize.width + hideFrame.size.width
        case .bottom:
            hideFrame.origin.y = screenSize.height
        default:
            break;
        }
        return hideFrame
    }

    @objc func applicationDidChangeStatusBarOrientation() {
        if EBCustomBanner.sharedBanners.count == 0 {
            return
        }
        if currentIsLandscape {
            EBCustomBanner.sharedBanners.forEach{ $0.view.frame = $0.maker.landscapeFrame }
        } else {
            EBCustomBanner.sharedBanners.forEach{ $0.view.frame = $0.maker.portraitFrame}
        }
    }

}

   
