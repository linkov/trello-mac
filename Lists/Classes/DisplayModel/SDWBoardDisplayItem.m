//
//  SDWBoardDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWBoardDisplayItem.h"
#import "SDWListDisplayItem.h"

@interface SDWBoardDisplayItem ()

@property (readwrite) SDWMBoard *model;
@property (readwrite) NSArray <SDWListDisplayItem *> *lists;

@end


@implementation SDWBoardDisplayItem

- (instancetype)initWithModel:(SDWMBoard *)model crownListIDs:(NSArray *)crownIDs {
    NSParameterAssert(model);
    self = [self initWithModel:model];
    self.lists = [self.lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"trelloID IN %@",crownIDs]];
    
    return self;
    
}

- (instancetype)initWithModel:(SDWMBoard *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.position = model.primitivePositionValue;
        self.starred = model.starredValue;
        
        NSSortDescriptor *sortByPos = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.model.lists.count];
        for (SDWMList *list in self.model.lists ) {
            SDWListDisplayItem *listItem = [[SDWListDisplayItem alloc]initWithModel:list];
            [arr addObject:listItem];
            
        }
        
        self.lists = [[arr copy] sortedArrayUsingDescriptors:@[sortByPos]];
        
        

    }
    return self;
    
}


@end


@implementation SDWBoardDisplayItem (TreeView)

- (BOOL)isLeaf {
    return NO;
}

- (NSArray *)children {
    
    return  [self lists];
}

@end
