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
@property NSUInteger contextRow;

@end

@protocol SDWBoardsListOutlineViewDelegate

@optional

- (void)outlineviewShouldDelete:(WSCBoardsOutlineView *)outlineView;


@end