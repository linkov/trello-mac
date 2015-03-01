//
//  SDWSingleCardTableCellView.m
//  Lists
//
//  Created by alex on 2/11/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSingleCardTableCellView.h"
#import "SDWCardListView.h"

@interface SDWSingleCardTableCellView () <NSTextFieldDelegate>

@end

@implementation SDWSingleCardTableCellView

- (void)awakeFromNib {

    self.textField.editable = NO;
    self.textField.delegate = self;
}

@end
