//
//  WSCBoardsOutlineView.h
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SDWBoardsListOutlineViewDelegate

@optional

- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow;
- (void)outlineviewShouldAddListBelowRow:(NSUInteger)listRow;

@end

@interface WSCBoardsOutlineView : NSOutlineView

@property (weak) id <SDWBoardsListOutlineViewDelegate> menuDelegate;

@end
