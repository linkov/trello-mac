//
//  SDWApplicationLoader.h
//  Lists
//
//  Created by alex on 5/24/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

@interface SDWApplicationManager : NSObject

/**
 * Set SDWMainSplitViewController as a root view controller for the given window
 * @param window - Application window
 */
- (void)installRootViewControllerIntoWindow:(NSWindow *)window;

- (void)handleGetUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)reply;

@end
