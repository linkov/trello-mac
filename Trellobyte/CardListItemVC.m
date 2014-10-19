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

    // forward selection to the prototype view
    [(CardListView *)self.view setSelected:selected];
}

@end
