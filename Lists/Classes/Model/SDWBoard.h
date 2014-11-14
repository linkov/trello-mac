//
//  SDWBoard.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWSourceListModel.h"
#import <Foundation/Foundation.h>

@interface SDWBoard : SDWSourceListModel

@property (nonatomic, strong) NSString *boardID;
@property (nonatomic, strong) NSString *name;
@property NSUInteger pos;
@property NSUInteger fontSize;

@end
