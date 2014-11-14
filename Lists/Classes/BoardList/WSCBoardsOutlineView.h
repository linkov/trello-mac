//
//  WSCBoardsOutlineView.h
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

@protocol SDWBoardsListOutlineViewDelegate;

#import <Cocoa/Cocoa.h>

@interface WSCBoardsOutlineView : NSOutlineView

@property (weak) id <SDWBoardsListOutlineViewDelegate> menuDelegate;

@end

@protocol SDWBoardsListOutlineViewDelegate

@optional

- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow;
- (void)outlineviewShouldAddListBelowRow:(NSUInteger)listRow;


@end