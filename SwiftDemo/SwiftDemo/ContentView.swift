//
//  ContentView.swift
//  SwiftDemo
//
//  Created by pikacode on 2020/1/3.
//  Copyright © 2020 pikacode. All rights reserved.
//

import SwiftUI
import EBBannerViewSwift

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                /// ⭐️ Fast Way
                EBSystemBanner.show("some content")
            }) {
                Text("Fast Way")
            }
            Text("")
            Button(action: {
                
                let anyObj: Any? = nil
                /// ⭐️ Custom Way
                let banner = EBSystemBanner()
                                .style(.iOS13)
                                .icon(UIImage(named: "icon"))
                                .appName("Twitter")
                                .title("title")
                                .content("some content")
                                .date("now")
                                .vibrateOnMute(true)
                                .object(anyObj)
                                .sound(.name("sing.mp3"))
                                .onClick { (b) in
                                    print(b.title!)
                                    print(b.object!)
                                }
                                
                /// show
                banner.show()
            }) {
                Text("Custom Way")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
