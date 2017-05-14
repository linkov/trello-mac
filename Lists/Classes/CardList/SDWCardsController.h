//
//  CardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoard,SDWCard,SDWMList,SDWMCard;
#import <Cocoa/Cocoa.h>

@interface SDWCardsController : NSViewController

@property (strong) IBOutlet NSImageView *onboardingImage;

- (void)setupCardsForList:(SDWMList *)list;
- (void)reloadCards;
- (void)clearCards;

- (void)updateCardDetails:(SDWMCard *)card localOnly:(BOOL)local;
- (void)showCardSavingIndicator:(BOOL)show;

@end
