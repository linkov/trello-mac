//
//  SDWCardsListViewController.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Cocoa;
#import "SDWCardsListUserInterface.h"
#import "SDWCardsListModuleDelegate.h"
#import "SDWCardsListModuleInterface.h"

@interface SDWCardsListViewController : NSViewController <SDWCardsListUserInterface>

@property (nonatomic, strong) id<SDWCardsListModuleInterface> eventHandler;
@property (nonatomic, weak) id<SDWCardsListModuleDelegate> moduleDelegate;

@end
