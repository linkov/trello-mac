//
//  AppDelegate.m
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
//#import <Crashlytics/Crashlytics.h>
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "SDWAppSettings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MixpanelTracker.h"
#import "SDWMainSplitView.h"
#import "SDWMainSplitController.h"
#import "SDWCardsController.h"

@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;

@interface AppDelegate ()
@property (weak) IBOutlet NSMenuItem *dotMenu10;
@property (weak) IBOutlet NSMenuItem *dotMenu20;
@property (weak) IBOutlet NSMenuItem *dotMenu30;
@property (weak) IBOutlet NSMenuItem *dotMenu40;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self setupDotOption];
    NSApp.appearance = [NSAppearance appearanceNamed: NSAppearanceNameAqua];

    if (!SharedSettings.shouldShowCardLabels) {
        SharedSettings.shouldShowCardLabels = YES;
    }
    
    [SharedSettings setTodayWidgetUserToken:SharedSettings.userToken];

    [Fabric with:@[[Crashlytics class]]];
    
    [MSAppCenter start:@"b8a9c7d4-812c-421f-a3a1-9846465fb7ea" withServices:@[
                                                                              [MSAnalytics class],
                                                                              [MSCrashes class]
                                                                              ]];
    
    #ifdef PRODUCTION
    
        [MixpanelTracker startWithToken:@"671b5e87eee999e25d472a57666153df"];
    #endif
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



//- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
//    NSLog(@"in applicationShouldTerminateAfterLastWindowClosed");
//   return true;
//}

- (IBAction)print:(id)sender {
    SDWMainSplitView *splitview = [[NSApplication sharedApplication] mainWindow].contentView;
    SDWMainSplitController *controller = (SDWMainSplitController *) splitview.nextResponder;
    if (controller) {
        NSPrintOperation *op = [NSPrintOperation printOperationWithView:controller.cardsVC.view];
        [op runOperation];
    }
    

}

- (IBAction)showHelp:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://lists4trello.com/#manual"]];
    
}

- (IBAction)hideSideBar:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeSidebarStatusNotification object:nil];
}

- (IBAction)hideCardDetails:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeCardDetailsStatusNotification object:nil];
}

- (IBAction)toggleCardLabels:(id)sender {

    if (SharedSettings.shouldShowCardLabels == NO) {
        SharedSettings.shouldShowCardLabels = YES;
    } else {
        SharedSettings.shouldShowCardLabels = NO;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadListNotification object:nil];

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
            [self.dotMenu10 setState:1]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:0];
            break;
        case 20:
            SharedSettings.dotOption = SDWDotOptionNoDue;
            [self.dotMenu10 setState:0]; [self.dotMenu20 setState:1]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:0];
            break;
        case 30:
            SharedSettings.dotOption = SDWDotOptionOff;
            [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:1]; [self.dotMenu40 setState:0];
            break;
        case 40:
            SharedSettings.dotOption = SDWDotOptionHasOpenTodos;
            [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:1];
            break;

        default:
            break;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidChangeDotOptionNotification object:nil];


}

- (void)setupDotOption {

    if (!SharedSettings.dotOption) {
        SharedSettings.dotOption = SDWDotOptionHasOpenTodos;
        [self.dotMenu10 setState:1];
    } else {

        switch (SharedSettings.dotOption) {

            case SDWDotOptionHasDescription:
                [self.dotMenu10 setState:1]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:0];
                break;
            case SDWDotOptionNoDue:
                [self.dotMenu10 setState:0]; [self.dotMenu20 setState:1]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:0];
                break;

            case SDWDotOptionOff:
                [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:1]; [self.dotMenu40 setState:0];
                break;
            case SDWDotOptionHasOpenTodos:
                [self.dotMenu10 setState:0]; [self.dotMenu20 setState:0]; [self.dotMenu30 setState:0]; [self.dotMenu40 setState:1];
                break;

            default:
                break;
        }
    }
}


@end
