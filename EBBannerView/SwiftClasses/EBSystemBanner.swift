//
//  EBSystemBanner.swift
//  Pods-SwiftDemo
//
//  Created by pikacode on 2019/12/30.
//

import UIKit
import AudioToolbox

public enum EBBannerStyle: Int, CaseIterable {
    case iOS8 = 8
    case iOS9 = 9
    case iOS10 = 10
    case iOS11 = 11
    case iOS12 = 12
    case iOS13 = 13
}

public class EBSystemBanner: NSObject {

    /// Fast way to show `content` with all default values
    ///
    ///     EBSystemBanner.show("some content")
    @discardableResult
    public static func show(_ content: String) -> EBSystemBanner { return EBSystemBanner().content(content).show() }
   
    
    /// Create an instance and then Set the properties below instead of default values
    ///
    ///     EBSystemBanner()
    ///         .style(.iOS13)
    ///         .title("Jack")
    ///         .content("How are you?")
    ///         .show()
    ///
    /// To customize the default values, set the properties of EBSystemBannerMaker.default
    ///
    ///     EBSystemBannerMaker.default.appName = "Custom App Name"
    ///
    /// Some properties in the banner
    ///     ┌──────────────────────┐
    ///     │┌──┐                                                                  |
    ///     ││ icon |   appName                                     date     |
    ///     │└──┘                                                                  |
    ///     │  title                                                                         |
    ///     │  content                                                                   |
    ///     └──────────────────────┘
    public func style(_ style: EBBannerStyle)                    -> EBSystemBanner { return then { $0.maker.style = style } }
    
    public func icon(_ icon: UIImage?)                           -> EBSystemBanner { return then { $0.maker.icon = icon } }
    
    public func appName(_ appName: String?)                      -> EBSystemBanner { return then { $0.maker.appName = appName } }
    
    public func title(_ title: String?)                          -> EBSystemBanner { return then { $0.maker.title = title } }
    
    public func content(_ content: String?)                      -> EBSystemBanner { return then { $0.maker.content = content } }
    
    public func date(_ date: String?)                            -> EBSystemBanner { return then { $0.maker.date = date } }
    
    public func showDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.showDuration = duration } }
    
    public func hideDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.hideDuration = duration } }
    
    public func stayDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.stayDuration = duration } }
    
    public func spreadStayDuration(_ duration: TimeInterval)     -> EBSystemBanner { return then { $0.maker.spreadStayDuration = duration } }
    
    /// Pass an object to banner and then get it on click
    ///
    ///     let obj = CustomObject()
    ///     EBSystemBanner()
    ///         .object(obj)
    ///         .content("How are you?")
    ///         .show()
    ///         .onClick {
    ///             print($0.object!)
    ///         }
    public func object(_ object: Any?)                           -> EBSystemBanner { return then { $0.maker.object = object } }
    
    /// Play a sound when a banner appears
    ///
    ///     // .id(1312) is the stytem sound `Tritone`, which is also the default value
    ///     // To find all system ids, visit http://iphonedevwiki.net/index.php/AudioServices
    ///     EBSystemBanner()
    ///         .sound(.id(1312))
    ///         .content("something")
    ///         .show()
    ///
    ///     // A custom sound in your main bundle
    ///     EBSystemBanner()
    ///         .sound(.name("MySound.mp3"))
    ///         .content("some")
    ///         .show()
    public func sound(_ sound: EBBannerSound)                    -> EBSystemBanner { return then { $0.maker.sound = sound } }
    
    public func vibrateOnMute(_ bool: Bool)                      -> EBSystemBanner { return then { $0.maker.vibrateOnMute = bool } }
    
    /// when click a long text banner, spread it for all height or hide it, true = expand/false = hide, default is true
    public func showDetailsOrHideWhenClickLongText(_ bool: Bool) -> EBSystemBanner { return then { $0.maker.showDetailsOrHideWhenClickLongText = bool } }
    
    @discardableResult
    public func onClick(_ block: @escaping (EBSystemBanner) -> ()) -> EBSystemBanner { return then { $0.maker.onClick = block } }

    
    @discardableResult
    public func show() -> EBSystemBanner {
        view.show()
        return self
    }
    
    /// observe this notification to get a banner in your code when clicked
    static let onClickNotification: Notification.Name = Notification.Name(rawValue: "EBBannerViewOnClickNotification")
 
    
    
    /// private
    
    
    private let maker =  EBSystemBannerMaker.default
    
    private lazy var view: EBSystemBannerView = {
        let window = EBBannerWindow.shared
        var bannerView = EBSystemBanner.sharedBannerViews.filter{ $0.style == style }.first
        
        if bannerView == nil {
            let views = Bundle(for: EBSystemBanner.self).loadNibNamed("EBSystemBannerView", owner: nil, options: nil)!
            let index = min(style.rawValue - 9, views.count - 1)
            let view = views[index] as! EBSystemBannerView
            view.addNotification()
            view.addGestureRecognizer()
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 3.5
            view.layer.shadowOpacity = 0.35
            view.layer.shadowOffset = .zero
            EBSystemBanner.sharedBannerViews.append(view)
            bannerView = view
        }
        bannerView?.maker = maker
        if style == .iOS9 {
            bannerView?.dateLabel.textColor = UIColor.color(at: bannerView!.dateLabel.center).withAlphaComponent(0.7)
            let lineCenter = bannerView!.lineView.center
            bannerView?.lineView.backgroundColor = UIColor.color(at: CGPoint(x: lineCenter.x, y: lineCenter.y - 7)).withAlphaComponent(0.5)
        }
        return bannerView!
    }()
    
}

extension EBSystemBanner: EBThen {}

// MARK: -  private method

extension EBSystemBanner {
            
    private static var sharedBannerViews = [EBSystemBannerView]()

    //u don't have to call hide, this only use for (long_text && forbidAutoHiddenWhenSwipeDown = true)
    func hide() {
        view.hide()
    }
    
    private static var current: EBSystemBannerView? {
        let view = EBBannerWindow.shared.rootViewController?.view.subviews.last
        if let aview = view as? EBSystemBannerView, view?.superview != nil {
            let banner = sharedBannerViews.filter{ $0 == aview }.first
            return banner
        } else {
            return nil
        }
    }
    
}

// MARK: -  convenience get method

extension EBSystemBanner {
    var style: EBBannerStyle                     { return maker.style }
    var icon: UIImage?                           { return maker.icon }
    var appName: String?                         { return maker.appName }
    var title: String?                           { return maker.title }
    var content: String?                         { return maker.content }
    var date: String?                            { return maker.date }
    var showDuration: TimeInterval               { return maker.showDuration }
    var hideDuration: TimeInterval               { return maker.hideDuration }
    var stayDuration: TimeInterval               { return maker.stayDuration }
    var spreadStayDuration: TimeInterval         { return maker.spreadStayDuration }
    var object: Any?                             { return maker.object }
    var sound: EBBannerSound                     { return maker.sound }
    var vibrateOnMute: Bool                      { return maker.vibrateOnMute }
    var showDetailsOrHideWhenClickLongText: Bool { return maker.showDetailsOrHideWhenClickLongText }
    var onClick: (EBSystemBanner) -> ()            { return maker.onClick }
}

//偷偷写个then，没人看到我 没人看到我🙈
protocol EBThen {}
extension EBThen where Self: AnyObject {
  func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}




 
