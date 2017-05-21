//
//  SDWLabelDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWLabelDisplayItem.h"
#import "SDWMLabel.h"

@interface SDWLabelDisplayItem ()

@property (readwrite) SDWMLabel *model;

@end

@implementation SDWLabelDisplayItem


- (instancetype)initWithModel:(SDWMLabel *)model {
    NSParameterAssert(model);
    self = [super init];
    
    if (self) {
        self.model = model;
        self.trelloID = model.trelloID;
        self.name = model.name;
        self.color = model.color;
        
        
    }
    return self;
}

@end
