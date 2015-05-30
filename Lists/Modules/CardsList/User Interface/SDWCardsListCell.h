//
//  SDWCardsListCell.h
//  Lists
//
//  Created by alex on 5/30/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWCardsListCell : NSTableCellView

+ (NSNib *)nib;

- (void)setSelected:(BOOL)isSelected;

@end
