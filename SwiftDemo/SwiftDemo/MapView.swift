//
//  MapView.swift
//  SwiftDemo
//
//  Created by pikacode on 2019/12/17.
//  Copyright © 2019 pikacode. All rights reserved.
//

import SwiftUI
import MapKit
    
struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 22, longitude: 114)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct MKMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
