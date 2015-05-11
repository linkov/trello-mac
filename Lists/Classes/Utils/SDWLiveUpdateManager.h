//
//  SDWLiveUpdateManager.h
//  Lists
//
//  Created by alex on 11/27/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SDWUpdateManagerCompletion)( NSArray *syncedData );

@interface SDWLiveUpdateManager : NSObject

+ (instancetype)sharedManager;

- (void)startUpdatingListID:(NSString *)listID;
- (void)stopUpdating;

@end
