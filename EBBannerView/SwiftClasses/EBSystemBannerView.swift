//
//  EBSystemBannerView.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2019/12/30.
//

import UIKit

class EBSystemBannerView: UIView {

 
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if frame.contains(point) {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }

}


extension UIColor {
    
    static func color(at point: CGPoint) -> UIColor? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        UIGraphicsBeginImageContext(window.frame.size)
        guard let con = UIGraphicsGetCurrentContext() else { return nil }
        window.layer.render(in: con)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        let w = image?.size.width ?? 0
        let h = image?.size.height ?? 0
        guard CGRect(x: 0, y: 0, width: w, height: h).contains(point) else { return nil }
        guard let cgImage = image?.cgImage else { return nil }
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
