//
//  SDWRootModuleInterface.h
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@class SDWListManaged;

@protocol SDWRootModuleInterface <NSObject>

- (void)handleSelectList:(SDWListManaged *)list;
- (void)doLogout;
- (void)updateUserInterface;

@end
