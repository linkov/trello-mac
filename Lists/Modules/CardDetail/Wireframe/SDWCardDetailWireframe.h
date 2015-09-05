//
//  SDWCardDetailWireframe.h
//  Lists
//
//  Created by alex on 9/5/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;
#import "SDWCardDetailModuleDelegate.h"

@interface SDWCardDetailWireframe : NSObject

- (NSViewController *)cardDetailUserInterfaceWithDelegate:(id<SDWCardDetailModuleDelegate>)delegate;

@end
