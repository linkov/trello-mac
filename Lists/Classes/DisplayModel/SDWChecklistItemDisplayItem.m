//
//  SDWChecklistItemItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWChecklistItemDisplayItem.h"
#import "SDWMChecklistItem.h"
#import "SDWChecklistDisplayItem.h"

@interface SDWChecklistItemDisplayItem ()

@property (readwrite) SDWMChecklistItem *model;

@end

@implementation SDWChecklistItemDisplayItem

- (instancetype)initWithModel:(SDWMChecklistItem *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.position = model.positionValue;
        self.state = model.state;
        
        
        
    }
    return self;
}

- (BOOL)isOpen {
    return ([self.state  isEqualToString:@"incomplete"]);
}

- (void)setIsOpen:(BOOL)isOpen {
    
}

- (SDWChecklistDisplayItem *)checklist {
    return [[SDWChecklistDisplayItem alloc]initWithModel:self.model.checklist];
}


@end
