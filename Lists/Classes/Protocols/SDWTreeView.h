//
//  SDWTreeView.h
//  Lists
//
//  Created by Alex Linkov on 5/7/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDWTreeView <NSObject>

- (BOOL)isLeaf;
- (NSArray *)children;

@end

NS_ASSUME_NONNULL_END
