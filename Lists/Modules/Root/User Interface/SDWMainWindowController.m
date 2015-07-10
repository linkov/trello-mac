//
//  SDWMainWindowController.m
//  Lists
//
//  Created by alex on 11/4/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWMainWindowController.h"

@interface SDWMainWindowController () <NSWindowDelegate>

@end

@implementation SDWMainWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;

    return self;
}

@end
