//
//  EBSystemBannerView.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2019/12/30.
//

import UIKit
import AudioToolbox

class EBSystemBannerView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    var maker: EBSystemBannerMaker!
    
    private var isSpread = false
    private var hideTimer: Timer?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if frame.contains(point) {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
  
    

    
    
}
 
extension EBSystemBannerView {
     
    var style: EBBannerStyle { return EBBannerStyle(rawValue: tag)! }

    var isiPhoneX: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        } else {
            return false
        }
    }
    
    var standardHeight: CGFloat {
        switch style {
        case .iOS8, .iOS9: return 70
        case .iOS10, .iOS11, .iOS12, .iOS13: return 90
        }
    }
    
    var calculatedContentHeight: CGFloat {
        let size = CGSize(width: contentLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let calculatedHeight = ((contentLabel.text ?? "") as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font : contentLabel.font.pointSize], context: nil).size.height
        return calculatedHeight
    }

    var isPortrait: Bool { return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height }

    var fixedX: CGFloat { return  (isiPhoneX && !isPortrait) ? 128 : 0 }
    
    var fixedY: CGFloat { return  (isiPhoneX && isPortrait) ? 33 : 0 }
    
    var fixedWidth: CGFloat { return  (isiPhoneX && !isPortrait) ? 556 : UIScreen.main.bounds.size.width }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarOrientation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc private func applicationDidChangeStatusBarOrientation() {
        if superview == nil { return }
        frame = CGRect(x: fixedX, y: fixedY, width: fixedWidth, height: standardHeight)
    }
    
    func addGestureRecognizer() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpSelector))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSelector))
        addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownSelector))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeUpSelector(ges: UISwipeGestureRecognizer) {
        if ges.direction == .up {
            hide()
        }
    }
        
    @objc func swipeDownSelector(ges: UISwipeGestureRecognizer) {
        guard ges.direction == .down && !lineView.isHidden else { return }
        
        if (UIDevice.current.systemVersion as NSString).intValue < 9 && maker.style.rawValue > 9 {
            contentLabel.numberOfLines = 0
        }
        
        isSpread = true
        lineView.isHidden = true

        hideTimer?.invalidate()
        hideTimer = nil
        hideTimer = Timer.scheduledTimer(timeInterval: maker.spreadStayDuration, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
        let originContentHeight = contentLabel.frame.size.height
        UIView.animate(withDuration: maker.hideDuration, delay: 0, usingSpringWithDamping: EBSystemBannerView.damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: self.fixedX, y: self.fixedY, width: self.standardHeight, height: self.calculatedContentHeight - originContentHeight + 1)
        }) { (finish) in
            self.frame = CGRect(x: self.fixedX, y: self.fixedY, width: self.fixedWidth, height: self.standardHeight + self.calculatedContentHeight - originContentHeight + 1)
        }
    }
    
    @objc func tapSelector(ges: UISwipeGestureRecognizer) {
        if maker.showDetailsOrHideWhenClickLongText && !lineView.isHidden {
            let ges = UISwipeGestureRecognizer()
            ges.direction = .down
            swipeDownSelector(ges: ges)
        } else {
            NotificationCenter.default.post(name: EBSystemBanner.onClickNotification, object: maker.object)
            hide()
        }
    }
    
    private static let damping: CGFloat = 0.8
    
    func show() {
        
        hideTimer?.invalidate()
        hideTimer = nil
        
        var soundID: SystemSoundID = 0
        switch maker.sound {
        case .id(let id):
            soundID = id
        case .name(let name):
            if let url = Bundle.main.url(forResource: name, withExtension: nil) {
                AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            }
        case .none:
            break;
        }
        
        EBMuteDetector.shared.detect { (isMute) in
            if isMute && self.maker.vibrateOnMute {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            } else {
                AudioServicesPlaySystemSound(soundID)
            }
        }
        
        imageView.image = maker.icon
        titleLabel.text = maker.title
        dateLabel.text = maker.date
        contentLabel.text = maker.content
        dateLabel.text = maker.date
        lineView.isHidden = calculatedContentHeight < 34
        //iOS8 使用新样式label显示bug
        if (UIDevice.current.systemVersion as NSString).intValue < 9 && maker.style.rawValue > 9 {
            contentLabel.numberOfLines = 1
        }
        EBBannerWindow.shared.rootViewController?.view.addSubview(self)
        
        frame = CGRect(x: fixedX, y: -standardHeight, width: fixedWidth, height: standardHeight)
        
        let damping = maker.style == .iOS9 ? 1 : EBSystemBannerView.damping
        
        EBBannerWindow.shared.isHidden = false
        
        UIView.animate(withDuration: maker.showDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: self.fixedX, y: self.fixedY, width: self.fixedWidth, height: self.standardHeight)
        }) { (finish) in
            self.hideTimer = Timer.scheduledTimer(timeInterval: self.maker.stayDuration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: maker.hideDuration, delay: 0, usingSpringWithDamping: EBSystemBannerView.damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: self.fixedX, y: -self.standardHeight - (self.frame.size.height - self.standardHeight), width: self.fixedWidth, height: self.frame.size.height)
        }) { (finish) in
            if (self.superview?.subviews.count == 1) {
                EBBannerWindow.shared.isHidden = true
            }
            self.removeFromSuperview()
        }
    }

}

extension UIColor {
    
    static func color(at point: CGPoint) -> UIColor {
        guard let window = UIApplication.shared.keyWindow else { return .clear }
        UIGraphicsBeginImageContext(window.frame.size)
        guard let con = UIGraphicsGetCurrentContext() else { return .clear }
        window.layer.render(in: con)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        let w = image?.size.width ?? 0
        let h = image?.size.height ?? 0
        guard CGRect(x: 0, y: 0, width: w, height: h).contains(point) else { return .clear }
        guard let cgImage = image?.cgImage else { return .clear }
        image = nil
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * 1
        let bitsPerComponent = 8
        var pixelData: [CGFloat] = [0, 0, 0, 0]
        let x = trunc(point.x)
        let y = trunc(point.y)
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.last.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        context?.setBlendMode(.copy)
        context?.translateBy(x: -x, y: y-h)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: w, height: h))
        UIGraphicsEndImageContext()
        let r = pixelData[0]/255
        let g = pixelData[1]/255
        let b = pixelData[2]/255
        let a = pixelData[3]/255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
