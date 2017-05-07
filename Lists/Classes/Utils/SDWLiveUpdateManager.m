//
//  SDWLiveUpdateManager.m
//  Lists
//
//  Created by alex on 11/27/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "AFTrelloAPIClient.h"
#import "SDWLiveUpdateManager.h"

@interface SDWLiveUpdateManager ()

@property (strong) NSString *activeListID;
@property BOOL shouldContinueUpdates;

@end

@implementation SDWLiveUpdateManager

+ (instancetype)sharedManager {
    static SDWLiveUpdateManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [SDWLiveUpdateManager new];

    });

    return _sharedManager;
}

- (void)fetchUpdates {

    if (!self.shouldContinueUpdates) {
        return;
    }

    NSString *datePlaceholder = @"";
    NSString *urlString = [NSString stringWithFormat:@"lists/%@/actions?since=%@",self.activeListID,datePlaceholder];
    [[AFTrelloAPIClient sharedClient] GET:urlString parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      NSArray *updates = responseObject;
                                      if (updates.count) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"syncUpdates" object:nil];
                                      }
                                      [self performSelector:@selector(fetchUpdates) withObject:nil afterDelay:10];

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                      CLS_LOG(@"err ask updates - %@",error.localizedDescription);
                                  }];
}

- (void)startUpdatingListID:(NSString *)listID {

    self.shouldContinueUpdates = YES;
    self.activeListID = listID;
    [self performSelector:@selector(fetchUpdates) withObject:nil afterDelay:10];
}

- (void)stopUpdating {
    self.shouldContinueUpdates = NO;
}

@end
