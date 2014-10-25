//
//  AppDelegate.h
//  testMacApp
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

@class CardInspectorVC;

#import <Cocoa/Cocoa.h>
#import "Board.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate>
@property (weak) IBOutlet NSProgressIndicator *progress;

@property (strong) NSMutableArray *cards;
@property (strong) IBOutlet NSOutlineView *outlineView;
@property (strong) IBOutlet NSArrayController *boardsArrayController;
@property (strong) IBOutlet NSArrayController *cardsArrayController;
@property (strong) IBOutlet NSTreeController *boardsTreeController;
@property (weak) IBOutlet NSCollectionView *cardCollection;

@property (strong) Board *board;
@property (strong) NSArray *boards;
@property (weak) IBOutlet NSLayoutConstraint *verticalSpaceToProgress;
@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSLayoutConstraint *zeroTopSpace;
@property (strong) IBOutlet NSLayoutConstraint *verticalBottomSpaceToProgress;
@property (weak) IBOutlet NSView *rightView;
@property (weak) IBOutlet NSLayoutConstraint *leadingSpaceToScrollView;
@property (weak) IBOutlet NSView *cardInspector;
@property (weak) IBOutlet CardInspectorVC *cardInspectorVC;

@end

