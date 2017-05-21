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
        self.hasOpenTodos = [model hasOpenTodos];
        self.list = [[SDWListDisplayItem alloc]initWithModel:model.list];
        self.board = [[SDWBoardDisplayItem alloc]initWithModel:model.board];
    }
    return self;

}

- (NSArray <SDWUserDisplayItem *> *)members {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.model.members.count];
    for (SDWMUser *user in self.model.members) {
        SDWUserDisplayItem *item = [[SDWUserDisplayItem alloc]initWithModel:user];
        [arr addObject:item];
    }
    
    return [arr copy];
}

- (NSArray <SDWLabelDisplayItem *> *)labels {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.model.labels.count];
    for (SDWMLabel *model in self.model.labels) {
        SDWLabelDisplayItem *item = [[SDWLabelDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
}


@end
