//
//  SDWCardDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWMCard.h"

@class SDWUserDisplayItem,SDWLabelDisplayItem,SDWListDisplayItem,SDWBoardDisplayItem;

@interface SDWCardDisplayItem : NSObject

@property (readonly) SDWMCard *model;

@property NSString *trelloID;

@property NSString *cardDescription;
@property NSDate *dueDate;
@property NSDate *lastUpdate;
@property SDWListDisplayItem *list;
@property SDWBoardDisplayItem *board;

@property NSString *name;
@property int64_t position;

@property int checkItemsCount;
@property int checkItemsCheckedCount;


- (instancetype)initWithModel:(SDWMCard *)model;

- (NSArray <SDWUserDisplayItem *> *)members;
- (NSArray <SDWLabelDisplayItem *> *)labels;

- (BOOL)hasOpenChecklistItems;

@end
