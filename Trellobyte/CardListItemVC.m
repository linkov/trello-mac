//
//  CardListItemVC.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "CardListView.h"
#import "CardListItemVC.h"

@implementation CardListItemVC

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (selected || self.isDropping) {
        self.textColor = [NSColor whiteColor];
    }
    else {
        self.textColor = [NSColor blackColor];
    }

    [(CardListView *)[self view] setSelected:self.isDropping ? YES : selected];
}

- (void)viewDidLayout {

    [super viewDidLayout];

}

@end
