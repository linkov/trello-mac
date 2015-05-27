//
//  SDWCardsListDataSource.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

@interface SDWCardsListDataSource : NSObject <NSTableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items;

@end
