//
//  SDWCardDetailViewController.m
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardDetailViewController.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "NSColor+AppColors.h"

/*-------Models-------*/

@interface SDWCardDetailViewController ()

@end

@implementation SDWCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.eventHandler updateUserInterface];
}

- (void)setupUI {
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor appBackgroundColorDark] CGColor]];
}

@end
