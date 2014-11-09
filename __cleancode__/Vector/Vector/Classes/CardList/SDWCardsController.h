//
//  CardsController.h
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoard;
#import <Cocoa/Cocoa.h>

@interface SDWCardsController : NSViewController

- (void)setupCardsForList:(SDWBoard *)list parentList:(SDWBoard *)parentList;
- (void)reloadCards;
- (void)clearCards;

@property (strong) IBOutlet NSProgressIndicator *loadingIndicator;

@end
