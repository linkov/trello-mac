//
//  SDWBoardsListModuleInterface.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;

@class SDWListManaged;
@protocol SDWBoardsListModuleInterface <NSObject>

- (void)updateUserInterface;
- (void)selectList:(SDWListManaged *)list;

@end
