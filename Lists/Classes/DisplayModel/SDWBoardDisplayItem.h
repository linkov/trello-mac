//
//  SDWBoardDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWMBoard.h"
#import "SDWTreeView.h"

@class SDWMList,SDWListDisplayItem, SDWLabelDisplayItem;

@interface SDWBoardDisplayItem : NSObject

@property (readonly) SDWMBoard *model;
@property (readonly) NSArray <SDWListDisplayItem *> *lists;
@property (readonly) NSArray <SDWLabelDisplayItem *> *labels;

@property NSString *trelloID;
@property NSString *name;
@property int64_t position;
@property BOOL starred;


- (instancetype)initWithModel:(SDWMBoard *)model;
- (instancetype)initWithModel:(SDWMBoard *)model crownListIDs:(NSArray *)crownIDs;

@end


@interface SDWBoardDisplayItem (TreeView) <SDWTreeView>

@end
