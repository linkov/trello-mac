//
//  SDWCardDetailsTextView.m
//  Lists
//
//  Created by alex on 12/14/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "SDWCardDetailsTextView.h"

@implementation SDWCardDetailsTextView

- (void)awakeFromNib {

  //  self.wantsLayer = YES;
    self.textColor = [NSColor colorWithHexColorString:@"E8E8E8"];
    self.backgroundColor = [NSColor clearColor];
 //   self.textContainerInset = CGSizeMake(4, 4);
  //  self.layer.cornerRadius = 1.5;

//    NSShadow* shadow = [[NSShadow alloc] init];
//   self.layer.shadowRadius = 2; //set how many pixels the shadow has
//    self.layer.shadowOffset = NSMakeSize(2, -2); //the distance from the text the shadow is dropped
//    self.layer.shadowColor = [NSColor whiteColor].CGColor;
   // self.layer.sh shadow = shadow;

}

@end
