//
//  LabelViewItem.m
//  Lists
//
//  Created by Alex Linkov on 1/29/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

#import "LabelViewItem.h"

@interface LabelViewItem ()

@end

@implementation LabelViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    self.view.layer.cornerRadius = 2;
//    self.view.layer.masksToBounds = YES;
    
    
    self.view.shadow = [NSShadow new];

    self.mainTextField.wantsLayer = YES;
}

@end
