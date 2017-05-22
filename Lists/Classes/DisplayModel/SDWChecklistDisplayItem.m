//
//  SDWChecklistDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWChecklistDisplayItem.h"
#import "SDWMChecklist.h"
#import "SDWChecklistItemDisplayItem.h"
#import "SDWMChecklistItem.h"

@interface SDWChecklistDisplayItem ()

@property (readwrite) SDWMChecklist *model;

@end

@implementation SDWChecklistDisplayItem

- (instancetype)initWithModel:(SDWMChecklist *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.position = model.positionValue;
        
        NSMutableArray *arr = [NSMutableArray new];
        for (SDWMChecklistItem *item in self.model.items ) {
            SDWChecklistItemDisplayItem *cardItem = [[SDWChecklistItemDisplayItem alloc]initWithModel:item];
            [arr addObject:cardItem];
            
        }
        
        self.items = [arr copy];
        
        
        
    }
    return self;
}


- (BOOL)hasOpenChecklistItems {
    return  ([[self items] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isOpen == 1"]].count > 0);
}

- (void)setHasOpenChecklistItems:(BOOL)hasOpenChecklistItems {
    
}



@end
