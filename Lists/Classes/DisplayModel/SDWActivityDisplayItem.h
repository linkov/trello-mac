//
//  SDWActivityDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/22/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDWMActivity;

@interface SDWActivityDisplayItem : NSObject

@property (readonly) SDWMActivity *model;
@property NSString *trelloID;
@property NSString *memberInitials;
@property NSString *dateString;
@property NSString *content;
@property NSDate *time;

- (instancetype)initWithModel:(SDWMActivity *)model;

@end
