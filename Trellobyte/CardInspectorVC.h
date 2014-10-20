//
//  CardInspectorVC.h
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class Card;

#import <Cocoa/Cocoa.h>

@interface CardInspectorVC : NSViewController
@property (weak) NSArrayController *labelsArray;
@property (weak) NSCollectionView *labelCollection;

@property (strong,nonatomic) Card *activeCard;
@property (weak) IBOutlet NSBox *mainView;
@end
