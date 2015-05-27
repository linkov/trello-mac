//
//  SDWCardsListWireframe.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "SDWCardsListModuleDelegate.h"

@interface SDWCardsListWireframe : NSObject

- (NSViewController *)cardsListUserInterfaceWithDelegate:(id<SDWCardsListModuleDelegate>)delegate;

@end
