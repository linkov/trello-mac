//
//  SDWBoardsListUserInterface.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
#import "SDWSourceListItem.h"

@protocol SDWBoardsListUserInterface <NSObject>

- (void)showLoadingIndicator;
- (void)dismissLoadingIndicator;
- (void)showNoContentMessage;
- (void)setCrown:(BOOL)on;
- (void)showContentWithItems:(NSArray *)items;
- (void)expandToSelectedList:(id<SDWSourceListItem>)listItem;
- (void)reloadEntries;

@end
