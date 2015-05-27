//
//  SDWCardsListUserInterface.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;

@protocol SDWCardsListUserInterface <NSObject>

- (void)showListTitle:(NSString *)title;
- (void)showNoContentMessage;
- (void)showContentWithItems:(NSArray *)items;
- (void)reloadEntries;

@end
