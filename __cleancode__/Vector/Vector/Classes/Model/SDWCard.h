//
//  SDWCard.h
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWCard : AFRecordModel

@property NSString *cardID;
@property (nonatomic, strong) NSString *name;
@property NSUInteger pos;
@property NSArray *members;
@property NSArray *users;
@property (nonatomic,strong) NSString *owner;
@property (strong) NSArray *labels;

@end
