//
//  SDWApplicationLoader.m
//  Lists
//
//  Created by alex on 5/24/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWApplicationLoader.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWRootWireframe.h"
#import "SDWCoreDataManager.h"

/*-------Models-------*/

@implementation SDWApplicationLoader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureUI];
        [self configureData];
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

#pragma mark - Helpers

- (void)configureData {
//    [[CNIDataModelManager manager] deleteAllTrackinsWithCompletion:nil];
//    [[CNIDataModelManager manager] saveContext];
}

- (void)configureUI {
//    [SVProgressHUD setRingThickness:5];
//    [SVProgressHUD setForegroundColor:[UIColor brandColor]];
}

@end
