//
//  CardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoard,SDWCard,SDWMList;
#import <Cocoa/Cocoa.h>

@interface SDWCardsController : NSViewController

@property (strong) IBOutlet NSImageView *onboardingImage;

- (void)setupCardsForList:(SDWMList *)list parentList:(SDWBoard *)parentList;
- (void)reloadCards;
- (void)clearCards;

- (void)updateCardDetails:(SDWCard *)card localOnly:(BOOL)local;
- (void)showCardSavingIndicator:(BOOL)show;

@end
