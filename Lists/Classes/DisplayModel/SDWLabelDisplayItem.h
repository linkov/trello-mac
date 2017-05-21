//
//  SDWLabelDisplayItem.h
//  Lists
//
//  Created by Alex Linkov on 5/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDWMLabel;

@interface SDWLabelDisplayItem : NSObject

@property (readonly) SDWMLabel *model;

@property NSString *trelloID;
@property NSString *name;
@property NSString *color;

- (instancetype)initWithModel:(SDWMLabel *)model;

@end
