//
//  SDWShortcutsManager.h
//  Lists
//
//  Created by alex on 11/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface SDWShortcutsManager : NSObject

+ (instancetype)sharedManager;

- (void)handlekeyDown:(NSEvent *)theEvent;

@end
