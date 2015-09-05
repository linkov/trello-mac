//
//  SDWCardDetailModuleDelegate.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;
@class SDWCardBasicInfo;

@protocol SDWCardDetailModuleDelegate <NSObject>

- (void)cardDetailModuleDidMoveTaskToPosition:(NSUInteger)position;
- (void)cardDetailModuleDidDeleteTaskWithID:(NSString *)listsID;
- (void)cardDetailModuleDidAddTaskWithText:(NSString *)text;
- (void)cardDetailModuleDidChangeBasicCardInfo:(SDWCardBasicInfo *)cardInfo;

@end
