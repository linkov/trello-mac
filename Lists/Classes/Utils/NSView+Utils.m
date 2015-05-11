//
//  NSView+Utils.m
//  Lists
//
//  Created by alex on 11/3/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "NSView+Utils.h"

@implementation NSView (Utils)

- (instancetype)insertVibrancyViewBlendingMode:(NSVisualEffectBlendingMode)mode {
    Class vibrantClass = NSClassFromString( @"NSVisualEffectView" );
    if (vibrantClass) {
        NSVisualEffectView *vibrant = [[vibrantClass alloc] initWithFrame:self.bounds];
        [vibrant setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [vibrant setBlendingMode:mode];
        [self addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];

        return vibrant;
    }

    return nil;
}

@end
