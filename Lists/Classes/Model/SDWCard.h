//
//  SDWCard.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWCard : AFRecordModel

@property NSString *cardID;
@property (nonatomic, strong) NSString *name;
@property NSArray *members;
@property NSArray *users;
@property (nonatomic, strong) NSString *owner;
@property (strong) NSArray *labels;
@property (strong) NSString *boardID;
@property (strong) NSDate *lastUpdate;
@property NSUInteger position;
@property BOOL hasOpenTodos;
@property (strong) NSString *cardDescription;
@property (strong) NSDate *dueDate;
@property  NSUInteger commentsCount;

@property BOOL isSynced;

@end
