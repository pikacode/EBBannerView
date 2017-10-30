//
//  CustomView2.m
//  demo
//
//  Created by wxc on 2017/10/30.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "CustomView2.h"

#import "CustomView2Cell.h"

@interface CustomView2()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CustomView2

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomView2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomView2Cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CustomView2Cell" owner:nil options:nil].lastObject;
    }
    cell.customView = self.customView;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

@end
