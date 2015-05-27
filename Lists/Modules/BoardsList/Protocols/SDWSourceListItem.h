//
//  SDWSourceListItem.h
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;


@protocol SDWSourceListItem <NSObject>

- (NSArray *)children;
- (NSString *)itemName;
- (id)childAtIndex:(NSUInteger)index;
- (BOOL)isLeaf;

@end
