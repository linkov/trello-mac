//
//  SDWCardsListCell.h
//  Lists
//
//  Created by alex on 5/30/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import Cocoa;
#import "SDWTypesAndEnums.h"

@interface SDWCardsListCell : NSTableCellView

+ (NSNib *)nib;
- (void)   setSelected:(BOOL)isSelected;

@property (copy) SDWEmptyBlock returnBlock;
@property (copy) SDWEmptyBlock rightClickBlock;

@end
