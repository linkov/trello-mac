//
//  SDWApplicationLoader.m
//  Lists
//
//  Created by alex on 5/24/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWApplicationManager.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWRootWireframe.h"
#import "SDWCoreDataManager.h"
#import "SDWAppSettings.h"
#import "Constants.h"

/*-------Models-------*/

@implementation SDWApplicationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureUI];
        [self configureData];
        [self configureAnalytics];
    }
    return self;
}

#pragma mark - Interface

- (void)installRootViewControllerIntoWindow:(NSWindow *__nonnull)window {
    [[SDWCoreDataManager manager] setupCoreDataWithCompletion:^{
        [[SDWCoreDataManager manager] setupMockAdminUser];
        SDWRootWireframe *rootWireframe = [SDWRootWireframe new];
        [rootWireframe showRootUserInterfaceInWindow:window];
    }];
}

- (void)handleGetUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)reply {
    NSString *token = [[[event descriptorAtIndex:1] stringValue] stringByReplacingOccurrencesOfString:@"lists://authorize#token=" withString:@""];

    if (token.length > 0) {
        SharedSettings.userToken = token;
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidReceiveUserTokenNotification
                                                            object:nil userInfo:@{@"token": token}];
    }
}

#pragma mark - Helpers

- (void)configureAnalytics {
    [Fabric with:@[CrashlyticsKit]];

    //[Crashlytics startWithAPIKey:@"7afe2a1f919e83706ec88df871b173b4faf5c453"];
}

- (void)configureData {
//    [[CNIDataModelManager manager] deleteAllTrackinsWithCompletion:nil];
//    [[CNIDataModelManager manager] saveContext];
}

- (void)configureUI {
//    [SVProgressHUD setRingThickness:5];
//    [SVProgressHUD setForegroundColor:[UIColor brandColor]];
}

@end
