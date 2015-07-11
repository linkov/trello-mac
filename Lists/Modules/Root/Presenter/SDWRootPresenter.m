//
//  CNIRootPresenter.m
//  Lists
//
//  Created by alex on 5/25/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWRootPresenter.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "SDWAppSettings.h" //remove this
#import "Constants.h"

/*-------Models-------*/

@implementation SDWRootPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self subscribeToEvents];
    }

    return self;
}

#pragma mark - SDWRootModuleInterface

- (void)updateUserInterface {
    if (!SharedSettings.userToken) {
        [self.wireframe showLoginUI];
    }
}

- (void)doLogout {
    SharedSettings.userToken = nil;
    [self.wireframe showLoginUI];
}

- (void)handleSelectList:(SDWListManaged *)list {
    [self.wireframe showCardsForCurrentList];
}

#pragma mark - Private

- (void)subscribeToEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSDWListsDidReceiveUserTokenNotification:) name:SDWListsDidReceiveUserTokenNotification object:nil];
}

- (void)handleSDWListsDidReceiveUserTokenNotification:(NSNotification *)note {
    [self.wireframe hideLoginUI];
    [self.wireframe showBoardsForCurrentUser];
}

@end
