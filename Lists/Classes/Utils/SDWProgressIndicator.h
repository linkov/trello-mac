//
//  SDWProgressIndicator.h
//  Lists
//
//  Created by alex on 11/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface SDWProgressIndicator : NSView

- (void)animateOnce;

- (void)stopAnimation;
- (void)startAnimation;

@end
