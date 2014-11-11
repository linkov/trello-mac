//
//  SDWSourceListModel.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWSourceListModel : AFRecordModel

@property (strong) NSArray *children;
@property BOOL isLeaf;

@end
