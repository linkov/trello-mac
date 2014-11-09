//
//  SDWAppSettings.h
//  Vector
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#define SharedSettings [SDWAppSettings sharedSettings]
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface SDWAppSettings : NSObject

+ (instancetype)sharedSettings;

@property (strong) NSString *userToken;
@property (strong,nonatomic) NSString *appToken;
@property (strong) NSArray *selectedListUsers;
@property (strong) NSString *lastSelectedList;

- (NSColor *)appBackgroundColorDark;
- (NSColor *)appBackgroundColor;
- (NSColor *)appHighlightColor;
- (NSColor *)appHighlightGreenColor;

@end
