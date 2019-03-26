//
//  AppDelegate.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)hideSideBar:(id)sender;
- (IBAction)hideCardDetails:(id)sender;
- (IBAction)toggleCardLabels:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)print:(id)sender;

@end

