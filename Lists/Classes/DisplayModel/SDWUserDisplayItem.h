//
//  SDWUserDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDWMUser;


@interface SDWUserDisplayItem : NSObject

@property (readonly) SDWMUser *model;

@property NSString *trelloID;
@property NSString *name;
@property NSString *initials;


- (instancetype)initWithModel:(SDWMUser *)model;

@end
