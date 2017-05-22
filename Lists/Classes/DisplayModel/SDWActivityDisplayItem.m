//
//  SDWActivityDisplayItem.m
//  Lists
//
//  Created by Alex Linkov on 5/22/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import "SDWActivityDisplayItem.h"
#import "SDWMActivity.h"
#import "Utils.h"

@interface SDWActivityDisplayItem ()

@property (readwrite) SDWMActivity *model;

@end


@implementation SDWActivityDisplayItem

- (instancetype)initWithModel:(SDWMActivity *)model {
    NSParameterAssert(model);
    self = [super init];
    if (self) {
        self.model = model;
        self.content = model.content;
        self.time = model.time;
        self.trelloID = model.trelloID;
        self.memberInitials = model.memberInitials;
        
        self.dateString = [Utils dateToString:self.time];

    }
    return self;
    
}



@end
