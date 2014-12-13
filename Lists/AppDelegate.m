//
//  AppDelegate.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "SDWAppSettings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

    [Crashlytics startWithAPIKey:@"7afe2a1f919e83706ec88df871b173b4faf5c453"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor*)reply
{

    NSString *token = [[[event descriptorAtIndex:1] stringValue] stringByReplacingOccurrencesOfString:@"lists://authorize#token=" withString:@""];

    if (token.length > 0) {
        SharedSettings.userToken = token;

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidReceiveUserTokenNotification
                                                        object:nil userInfo:@{@"token":token}];

}

-(void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    // Register ourselves as a URL handler for this URL
    [[NSAppleEventManager sharedAppleEventManager]
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:)
     forEventClass:kInternetEventClass
     andEventID:kAEGetURL];
}

- (IBAction)hideSideBar:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeSidebarStatusNotification object:nil];
}

- (IBAction)hideCardDetails:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeCardDetailsStatusNotification object:nil];
}

@end
