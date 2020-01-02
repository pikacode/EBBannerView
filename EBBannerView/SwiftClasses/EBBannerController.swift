//
//  EBBannerController.swift
//  EBBannerViewSwift
//
//  Created by pikacode on 2020/1/2.
//

import UIKit

class EBBannerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    static var orientations = UIInterfaceOrientationMask.portrait
    static var statusBarHidden = false
    
    static func setSupportedInterfaceOrientations(value: UIInterfaceOrientationMask) {
        orientations = value
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return EBBannerController.orientations
    }
    
    static func setStatusBarHidden(hidden: Bool) {
        EBBannerController.statusBarHidden = hidden
    }

}

 

//- (instancetype)init
//{
//    self = [self initWithNibName:@"EBBannerViewController" bundle:[NSBundle bundleForClass:self.class]];
//    if (self) {
//        
//    }
//    return self;
//}
// 
