//
//  SDWBoardsListWireframe.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

@protocol SDWBoardsListModuleDelegate;


@interface SDWBoardsListWireframe : NSObject

- (NSViewController *)boardsListUserInterfaceWithDelegate:(id<SDWBoardsListModuleDelegate>)delegate;

@end
