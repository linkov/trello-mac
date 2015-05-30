//
//  SDWCardsListCell.m
//  Lists
//
//  Created by alex on 5/30/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListCell.h"

@implementation SDWCardsListCell


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setSelected:(BOOL)isSelected {

    if (isSelected) {
        [self.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
    } else {
        [self.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    }
}

- (void)awakeFromNib {

    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    self.layer.cornerRadius = 1.5;
    self.layer.masksToBounds = YES;

}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {


}

- (void)setBackgroundFilters:(NSArray *)backgroundFilters {

}

#pragma mark - Utils

+ (NSNib *)nib {
    return [[NSNib alloc]initWithNibNamed:@"SDWCardsListCell" bundle:nil];
}

@end
