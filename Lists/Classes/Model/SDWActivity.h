//
//  SDWActivity.h
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AFRecordModel.h"

@interface SDWActivity : AFRecordModel

@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *content;
@property NSString *memberInitials;
@property NSDate *time;
@property (nonatomic) NSString *timeString;

@end
