//
//  SDWChecklistItem.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWChecklistItem : AFRecordModel

@property (strong) NSString *state;
@property (strong) NSString *itemID;
@property (strong) NSString *name;
@property (strong) NSString *listID;
@property (strong) NSString *listName;
@property NSUInteger position;

@end
