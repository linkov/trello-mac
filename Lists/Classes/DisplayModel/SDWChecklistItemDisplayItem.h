//
//  SDWChecklistItemItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDWMChecklistItem,SDWChecklistDisplayItem;

@interface SDWChecklistItemDisplayItem : NSObject

@property (readonly) SDWMChecklistItem *model;

@property NSString *trelloID;
@property NSString *name;
@property NSString *state;
@property int64_t position;
@property BOOL isOpen;

- (instancetype)initWithModel:(SDWMChecklistItem *)model;
- (SDWChecklistDisplayItem *)checklist;

@end
