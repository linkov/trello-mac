//
//  AppDelegate.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWAppSettings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor*)reply
{

    SharedSettings.userToken = [[[event descriptorAtIndex:1] stringValue] stringByReplacingOccurrencesOfString:@"vector://authorize#token=" withString:@""];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.sdwr.trello-mac.didReceiveUserTokenNotification" object:nil];

    NSLog(@"%@", event);
    
}

//- (void)applicationWillBecomeActive:(NSNotification *)notification {
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.sdwr.trello-mac.didReceiveUserTokenNotification" object:nil];
//
//}

-(void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    // Register ourselves as a URL handler for this URL
    [[NSAppleEventManager sharedAppleEventManager]
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:)
     forEventClass:kInternetEventClass
     andEventID:kAEGetURL];
}

@end
