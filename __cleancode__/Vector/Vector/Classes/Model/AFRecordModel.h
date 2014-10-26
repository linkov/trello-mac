//
//  AFRecordModel.h
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "AFRecordPathManager.h"
#import "AFTrelloAPIClient.h"
#import <Foundation/Foundation.h>

typedef void (^AFRecordCallback)(id, NSError *);

@interface AFRecordModel : NSObject

@property (strong) NSDictionary *attributes;

+ (void)findAll:(AFRecordCallback)block;
//+ (void)attribute:(NSString *)attribute withValue:(id)searchValue findAll:(AFRecordCallback)block;
//+ (void)attribute:(NSString *)attribute withValue:(id)searchValue findFirst:(AFRecordCallback)block;


- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)mapAttributesToProperties;

@end
