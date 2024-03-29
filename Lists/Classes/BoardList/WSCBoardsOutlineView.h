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

- (void)outlineviewShouldEditBoardAtRow:(NSUInteger)boardRow;
- (void)outlineviewShouldDeleteBoardAtRow:(NSUInteger)boardRow;
- (void)outlineviewShouldDeleteListAtRow:(NSUInteger)listRow;

- (void)outlineviewShoulMoveDownListAtRow:(NSUInteger)listRow;
- (void)outlineviewShoulMoveUpListAtRow:(NSUInteger)listRow;

- (void)outlineviewShouldAddListToBoardAtRow:(NSUInteger)boardRow;
- (void)outlineviewShouldAddListToTodayAtRow:(NSUInteger)listRow;


@end

@interface WSCBoardsOutlineView : NSOutlineView

@property (weak) id <SDWBoardsListOutlineViewDelegate> menuDelegate;

@end
