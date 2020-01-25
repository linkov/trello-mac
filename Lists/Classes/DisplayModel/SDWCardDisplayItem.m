//
//  SDWCardDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWCardDisplayItem.h"
#import "SDWUserDisplayItem.h"
#import "SDWLabelDisplayItem.h"
#import "SDWListDisplayItem.h"
#import "SDWBoardDisplayItem.h"

#import "SDWChecklistDisplayItem.h"
#import "SDWChecklistItemDisplayItem.h"

@interface SDWCardDisplayItem ()

@property (readwrite) SDWMCard *model;

@end


@implementation SDWCardDisplayItem

- (instancetype)initWithModel:(SDWMCard *)model {
    NSParameterAssert(model);
    self = [super init];
    if (self) {
        self.model = model;
        self.name = model.name;
        self.cardDescription = model.cardDescription;
        self.trelloID = model.trelloID;
        self.checkItemsCheckedCount = model.checkItemsCheckedCountValue;
        self.checkItemsCount = model.checkItemsCountValue;
        self.dueDate = model.dueDate;
        self.lastUpdate = model.lastUpdate;
        self.position = model.positionValue;
        self.list = [[SDWListDisplayItem alloc]initWithModel:model.list];
        self.board = [[SDWBoardDisplayItem alloc]initWithModel:model.list.board];
    }
    return self;

}

- (NSArray <SDWUserDisplayItem *> *)members {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (SDWMUser *user in [self.model members]) {
        SDWUserDisplayItem *item = [[SDWUserDisplayItem alloc]initWithModel:user];
        [arr addObject:item];
    }
    
    return [arr copy];
}



- (NSArray <SDWLabelDisplayItem *> *)labels {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (SDWMLabel *model in self.model.labels) {
        SDWLabelDisplayItem *item = [[SDWLabelDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
}


- (NSArray <SDWChecklistDisplayItem *> *)checklists {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (SDWMChecklist *model in self.model.checklists) {
        SDWChecklistDisplayItem *item = [[SDWChecklistDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
}

- (BOOL)hasOpenChecklistItems {
    BOOL checklistsLoaded = ([self.model checklists].count > 0);

    if (!checklistsLoaded) {
        if (self.model.checkItemsCountValue - self.model.checkItemsCheckedCountValue > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return  [[self checklists] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasOpenChecklistItems == 1"]].count;
}


@end
