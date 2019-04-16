//
//  SDWListDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWListDisplayItem.h"
#import "SDWCardDisplayItem.h"
#import "SDWBoardDisplayItem.h"

@interface SDWListDisplayItem ()

@property (readwrite) SDWMList *model;

@end



@implementation SDWListDisplayItem

- (instancetype)initWithModel:(SDWMList *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.cardCount = model.cards.count;
        self.position = model.primitivePositionValue;
        
        
        
    }
    return self;
    
}

- (NSArray<SDWCardDisplayItem *> *)cards {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (SDWMCard *card in self.model.cards ) {
        SDWCardDisplayItem *cardItem = [[SDWCardDisplayItem alloc]initWithModel:card];
        [arr addObject:cardItem];
        
    }
    self.cardCount = self.model.cards.count;
    return [arr copy];
}

- (SDWBoardDisplayItem *)board {
  return  [[SDWBoardDisplayItem alloc]initWithModel:self.model.board];
}

@end



@implementation SDWListDisplayItem (TreeView)

- (BOOL)isLeaf {
    return YES;
}

- (NSArray *)children {
    return nil;
}

@end
