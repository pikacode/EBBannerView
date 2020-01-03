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
        Button(action: {
            EBSystemBanner.show("content")
        }) {
            Text("Button")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
