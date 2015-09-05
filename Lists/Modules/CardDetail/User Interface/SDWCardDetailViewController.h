//
//  SDWCardDetailViewController.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Cocoa;
#import "SDWCardDetailModuleInterface.h"
#import "SDWCardDetailModuleDelegate.h"
#import "SDWCardDetailUserInterface.h"

@interface SDWCardDetailViewController : NSViewController <SDWCardDetailUserInterface>

@property (nonatomic, strong) id<SDWCardDetailModuleInterface> eventHandler;
@property (nonatomic, weak) id<SDWCardDetailModuleDelegate> moduleDelegate;

@end
