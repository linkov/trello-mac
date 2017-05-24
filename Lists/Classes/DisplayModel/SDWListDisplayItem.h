//
//  SDWListDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDWMList.h"
#import "SDWTreeView.h"


@class SDWMCard,SDWCardDisplayItem,SDWBoardDisplayItem;

@interface SDWListDisplayItem : NSObject

@property (readonly) SDWMList *model;

@property NSString *trelloID;
@property NSString *name;
@property int64_t position;

- (instancetype)initWithModel:(SDWMList *)model;
- (NSArray <SDWCardDisplayItem *> *)cards;
- (SDWBoardDisplayItem *)board;

@end

@interface SDWListDisplayItem (TreeView) <SDWTreeView>

@end
