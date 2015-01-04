//
//  SDWCheckItemTableCellView.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCheckItemTableCellView.h"

@implementation SDWCheckItemTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {

    self.wantsLayer = YES;
  //  self.layer.backgroundColor = [SharedSettings appBackgroundColor].CGColor;
}
- (IBAction)checkBoxClicked:(AAPLCheckBox *)sender {

    self.textField.enabled = !sender.checked;
    [self.delegate checkItemDidCheck:self];
}

@end
