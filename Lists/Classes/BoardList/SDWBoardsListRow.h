//
//  SDWBoardsListRow.h
//  Lists
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

@protocol SDWBoardsListRowDelegate;

#import <Cocoa/Cocoa.h>
#import "SDWListDisplayItem.h"

@interface SDWBoardsListRow : NSTableRowView

@property (weak) id <SDWBoardsListRowDelegate> delegate;
@property SDWListDisplayItem *list;

- (void)loadCardNumbers;

@end


@protocol SDWBoardsListRowDelegate

@optional

- (void)boardRowDidDoubleClick:(SDWBoardsListRow *)boardRow;


@end
