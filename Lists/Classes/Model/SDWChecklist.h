//
//  SDWChecklist.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWChecklist : AFRecordModel

@property (strong) NSString *listBoardID;
@property (strong) NSString *listCardID;
@property (strong) NSString *listID;
@property (strong) NSString *name;
@property NSUInteger position;
@property (strong) NSArray *items;

@end
