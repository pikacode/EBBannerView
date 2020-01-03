 

Pod::Spec.new do |s|
 
  s.name         = "EBBannerViewSwift"
  s.version      = "0.1.0.beta"
  s.summary      = "展示跟iOS9~13推送一样的横幅/提示音/振动，或自定义view|Show a banner the same with iOS9/10/11/12 nofitication(sound/vibrate), or customize."

 
  s.description  = <<-DESC
App在前台时展示跟iOS9,10,11,12推送通知一样UI的横幅/自动提示音或振动，而且支持自定义样式。Show a banner the same UI with iOS9,10,11,12 nofitication(auto play sound/vibrate) on foreground, support custom UI.
                   DESC

  s.homepage     = "https://github.com/pikacode/EBBannerView"

 

  s.license      = "MIT"
  
  s.author             = { "pikacode" => "pikacode@qq.com" }
 
 
   s.platform     = :ios, "8.0"
 

  s.source       = { :git => "https://github.com/pikacode/EBBannerView.git", :tag => "#{s.version}" }
 

  s.source_files  = "EBBannerView/SwiftClasses/*.{swift}"

#  s.exclude_files = "Classes/Exclude"

   #s.public_header_files = "EBBannerView/SwiftClasses/*.{swift}"


 

   s.resources = "EBBannerView/Classes/*.{xib,mp3}"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


   s.frameworks = "UIKit", "Foundation", "AudioToolbox"


   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
