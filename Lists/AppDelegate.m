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
@property (weak) IBOutlet NSMenuItem *dotMenu10;
@property (weak) IBOutlet NSMenuItem *dotMenu20;
@property (weak) IBOutlet NSMenuItem *dotMenu30;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self setupDotOption];

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




#pragma mark - Dot Option

- (IBAction)dotOptionFeedback:(id)sender {


    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];

    NSString *urlString =[NSString stringWithFormat:@"mailto:lists4trello@gmail.com"
                          "?subject=Lists%%20for%%20Trello%%20%@%%20-%%20Dot%%20behavior%%20feedback"
                          "&body=Hey,",version];

    (void) [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];

}

- (IBAction)changeDotOption:(NSMenuItem *)sender {

    switch (sender.tag) {
        case 10:
            SharedSettings.dotOption = SDWDotOptionHasDescription;
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeDotOptionNotification object:nil];
            [self.dotMenu10 setState:1]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0];
            break;
        case 20:
            SharedSettings.dotOption = SDWDotOptionNoDue;
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeDotOptionNotification object:nil];
            [self.dotMenu10 setState:0]; [self.dotMenu20 setState:1]; [self.dotMenu30 setState:0];
            break;
        case 30:
            SharedSettings.dotOption = SDWDotOptionOff;
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeDotOptionNotification object:nil];
            [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:1];
            break;

        default:
            break;
    }

}

- (void)setupDotOption {

    if (!SharedSettings.dotOption) {
        SharedSettings.dotOption = SDWDotOptionHasDescription;
        [self.dotMenu10 setState:1];
    } else {

        switch (SharedSettings.dotOption) {

            case SDWDotOptionHasDescription:
                [self.dotMenu10 setState:1]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0];
                break;
            case SDWDotOptionNoDue:
                [self.dotMenu10 setState:0]; [self.dotMenu20 setState:1]; [self.dotMenu30 setState:0];
                break;

            case SDWDotOptionOff:
                [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:1];
                break;

            default:
                break;
        }
    }
}

@end
