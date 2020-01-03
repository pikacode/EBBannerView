//
//  EBBannerWindow.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2020/1/2.
//

import UIKit

class EBBannerWindow: UIWindow {

    @available(iOS 13.0, *)
    public override init(windowScene: UIWindowScene){
        super.init(windowScene: windowScene)
    }
    
    static let shared: EBBannerWindow = {
        var window: EBBannerWindow
        if #available(iOS 13.0, *) {
            window = EBBannerWindow(windowScene: UIApplication.shared.keyWindow!.windowScene!)
        } else {
            window = EBBannerWindow(frame: .zero)
        }
        window.windowLevel = .alert
        window.layer.masksToBounds = false
        let keyWindow = UIApplication.shared.keyWindow
        window.makeKeyAndVisible()
        /* fix bug:
         EBBannerViewController setSupportedInterfaceOrientations -> Portrait
         push to a VC with orientation Left
         UITextFiled's pad will show a wrong orientation with Portrait
         */
        EBEmptyWindow.shared.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()
        EBBannerController.setSupportedInterfaceOrientations(value: [.portrait, .landscape])
        EBBannerController.setStatusBarHidden(hidden: false)
        let vc = EBBannerController()
        vc.view.backgroundColor = .clear
        let size = UIScreen.main.bounds.size
        vc.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        window.rootViewController = vc
        return window
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if #available(iOS 13.0, *) {
            print("")
        } else {
            removeObserver(self, forKeyPath: "frame")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" && !frame.equalTo(.zero) {
            frame = .zero
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view: UIView?
        for v in rootViewController?.view.subviews ?? [UIView]() {
            if v.frame.contains(point) {
                view = v
                break
            }
        }
        if view == nil {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.keyWindow?.hitTest(point, with: event)
            } else {
                return super.hitTest(point, with: event)
            }
        } else {
            let p = convert(point, to: view)
            return view?.hitTest(p, with: event)
        }
    }
    
}
  
 
