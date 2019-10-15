//
//  ViewController.m
//  demo13
//
//  Created by pikacode on 2019/10/15.
//  Copyright © 2019 pikacode. All rights reserved.
//

#import "ViewController.h"
#import <EBBannerView.h>

@interface ViewController ()

- (IBAction)action:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)action:(id)sender {
    [EBBannerView showWithContent:@"哈哈哈哈哈哈哈"];
}

@end
