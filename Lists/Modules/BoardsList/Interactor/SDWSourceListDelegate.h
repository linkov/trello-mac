//
//  SDWSourceListDelegate.h
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "SDWTypesAndEnums.h"

@interface SDWSourceListDelegate : NSObject

- (instancetype)initWithItems:(NSArray *)items
            cellDidClickBlock:(SDWDataBlock)block;

@end
