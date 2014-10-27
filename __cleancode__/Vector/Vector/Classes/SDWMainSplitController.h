//
//  SDWMainSplitController.h
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWCardsController.h"
#import "SDWCardViewController.h"
#import <Cocoa/Cocoa.h>

@interface SDWMainSplitController : NSSplitViewController


@property (strong) SDWCardsController *cardsVC;
@property (strong) SDWCardViewController *inspectorVC;

@end
