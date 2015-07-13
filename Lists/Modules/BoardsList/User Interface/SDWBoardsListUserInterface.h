//
//  SDWBoardsListUserInterface.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;

@protocol SDWBoardsListUserInterface <NSObject>

- (void)showLoadingIndicator;
- (void)dismissLoadingIndicator;
- (void)showNoContentMessage;
- (void)showContentWithItems:(NSArray *)items;
- (void)reloadEntries;

@end
