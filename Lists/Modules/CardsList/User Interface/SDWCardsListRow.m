//
//  SDWCardsListRow.m
//  Lists
//
//  Created by alex on 5/30/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//


#import "SDWCardsListRow.h"
#import "SDWCardsListCell.h"

@implementation SDWCardsListRow

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect {

}
- (void)drawSelectionInRect:(NSRect)dirtyRect {

}
- (void)drawSeparatorInRect:(NSRect)dirtyRect {

}

- (void)setSelected:(BOOL)selected {

    [super setSelected:selected];

   SDWCardsListCell *cell = [self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@",[SDWCardsListCell class]]].firstObject;

    if (cell) {
        [cell setSelected:selected];
    }

}

@end
