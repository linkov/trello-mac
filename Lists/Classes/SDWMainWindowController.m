//
//  SDWMainWindowController.m
//  Lists
//
//  Created by alex on 11/4/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWMainWindowController.h"
#import "SDWAppSettings.h"

@interface SDWMainWindowController () <NSWindowDelegate>

@end

@implementation SDWMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
}

- (void)windowDidUpdate:(NSNotification *)notification {
    NSWindow *win = notification.object;
    win.titlebarAppearsTransparent = YES;
    win.titleVisibility = NSWindowTitleHidden;
    win.styleMask = win.styleMask | NSWindowStyleMaskFullSizeContentView;
//    win.delegate = nil;
}

-(NSRect) windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame {
    if (newFrame.size.height == [NSScreen mainScreen].frame.size.height && newFrame.size.width != [NSScreen mainScreen].frame.size.width) {
        newFrame.size.width =  [NSScreen mainScreen].frame.size.width;
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsWillEnterFullscreenNotification object:nil userInfo:nil];
    } else if (newFrame.size.height == [NSScreen mainScreen].frame.size.height && newFrame.size.width == [NSScreen mainScreen].frame.size.width) {
        newFrame.size.height = [NSScreen mainScreen].frame.size.height/2;
         [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsWillExitFullscreenNotification object:nil userInfo:nil];
    }
    return newFrame;
}

-(void) windowWillEnterFullScreen:(NSNotification *)notification {
     [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsWillEnterFullscreenNotification object:nil userInfo:nil];
    
}

-(void) windowWillExitFullScreen:(NSNotification *)notification {
     [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsWillExitFullscreenNotification object:nil userInfo:nil];
}

- (BOOL)windowShouldClose:(NSWindow *)sender {
    
    [NSApp terminate:nil];
    
    return NO;
    
}




@end
