//
//  SDWChecklistDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDWMChecklist,SDWChecklistItemDisplayItem;

@interface SDWChecklistDisplayItem : NSObject

@property (readonly) SDWMChecklist *model;

@property NSString *trelloID;
@property NSString *name;
@property int64_t position;
@property BOOL hasOpenChecklistItems;

@property NSArray<SDWChecklistItemDisplayItem *> *items;

- (instancetype)initWithModel:(SDWMChecklist *)model;

@end
