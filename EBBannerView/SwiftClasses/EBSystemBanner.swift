//
//  EBSystemBanner.swift
//  Pods-SwiftDemo
//
//  Created by pikacode on 2019/12/30.
//

import UIKit

enum EBBannerStyle: Int, CaseIterable {
    case iOS8 = 8
    case iOS9 = 9
    case iOS10 = 10
    case iOS11 = 11
    case iOS12 = 12
    case iOS13 = 13
}

class EBSystemBanner: NSObject {

    /// Fast way to show `content` with all default values
    ///
    ///     EBSystemBanner.show("some content")
    @discardableResult
    static func show(_ content: String) -> EBSystemBanner { return EBSystemBanner().content(content).show() }
   
    
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
    func style(_ style: EBBannerStyle)                    -> EBSystemBanner { return then { $0.maker.style = style } }
    
    func icon(_ icon: UIImage?)                           -> EBSystemBanner { return then { $0.maker.icon = icon } }
    
    func appName(_ appName: String?)                      -> EBSystemBanner { return then { $0.maker.appName = appName } }
    
    func title(_ title: String?)                          -> EBSystemBanner { return then { $0.maker.title = title } }
    
    func content(_ content: String?)                      -> EBSystemBanner { return then { $0.maker.content = content } }
    
    func date(_ date: String?)                            -> EBSystemBanner { return then { $0.maker.date = date } }
    
    func showDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.showDuration = duration } }
    
    func hideDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.hideDuration = duration } }
    
    func stayDuration(_ duration: TimeInterval)           -> EBSystemBanner { return then { $0.maker.stayDuration = duration } }
    
    func spreadStayDuration(_ duration: TimeInterval)     -> EBSystemBanner { return then { $0.maker.spreadStayDuration = duration } }
    
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
    func object(_ object: Any?)                           -> EBSystemBanner { return then { $0.maker.object = object } }
    
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
    func sound(_ sound: EBBannerSound)                    -> EBSystemBanner { return then { $0.maker.sound = sound } }
    
    func vibrateOnMute(_ bool: Bool)                      -> EBSystemBanner { return then { $0.maker.vibrateOnMute = bool } }
    
    /// when click a long text banner, spread it for all height or hide it, true = expand/false = hide, default is true
    func showDetailsOrHideWhenClickLongText(_ bool: Bool) -> EBSystemBanner { return then { $0.maker.showDetailsOrHideWhenClickLongText = bool } }
    
    @discardableResult
    func onClick(_ block: @escaping (EBSystemBanner) -> ()) -> EBSystemBanner { return then { $0.maker.onClick = block } }

    
    @discardableResult
    func show() -> EBSystemBanner {
        
        
        
        return self
    }
    
    
    /// observe this notification to get a banner in your code when clicked
    static let onClickNotification: Notification.Name = Notification.Name(rawValue: "EBBannerViewOnClickNotification")
 
    
    
    /// private
    
    private static var current: EBSystemBanner?
    
    private let maker =  EBSystemBannerMaker.default
 
    private lazy var view: EBSystemBannerView = {
        return EBSystemBannerView()
    }()
}

extension EBSystemBanner: EBThen {}

// MARK: -  private method

extension EBSystemBanner {
    //u don't have to call hide, this only use for (long_text && forbidAutoHiddenWhenSwipeDown = true)
    func hide() {
        
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
