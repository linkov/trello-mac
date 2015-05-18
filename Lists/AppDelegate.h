//
//  AppDelegate.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDWPersistenceManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)hideSideBar:(id)sender;
- (IBAction)hideCardDetails:(id)sender;
- (IBAction)toggleCardLabels:(id)sender;

@end

