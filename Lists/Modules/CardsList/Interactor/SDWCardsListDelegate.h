//
//  SDWCardsListDelegate.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Foundation;
@import AppKit;
#import "JWCTableView.h"
#import "SDWTypesAndEnums.h"

@interface SDWCardsListDelegate : NSObject <JWCTableViewDelegate>

- (instancetype)initWithItems:(NSArray *)items
                  returnBlock:(SDWCellItemBlock)returnBlock
              rightClickBlock:(SDWCellItemBlock)rightClick;

@end
