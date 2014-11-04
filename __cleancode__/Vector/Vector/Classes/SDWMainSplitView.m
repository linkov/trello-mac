//
//  SDWMainSplitView.m
//  Vector
//
//  Created by alex on 11/4/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "NSColor+Util.h"
#import "SDWMainSplitView.h"

@implementation SDWMainSplitView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSColor*)dividerColor {
    return [NSColor colorWithHexColorString:@"1E5676"];
}

@end
