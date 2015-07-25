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

- (void)switchCrown:(BOOL)on;
- (void)selectList:(SDWListManaged *)list;
- (void)doLogout;
- (void)updateUserInterface;

@end
