//
//  ListRowViewController.m
//  Lists4TrelloToday
//
//  Created by Alex Linkov on 3/31/19.
//  Copyright © 2019 SDWR. All rights reserved.
//

#import "ListRowViewController.h"

@implementation ListRowViewController

- (NSString *)nibName {
    return @"ListRowViewController";
}

- (void)loadView {
    [super loadView];
    
    self.textField.stringValue =  self.taskName;
    
    if (self.isHeaderRow) {
        self.cardBox.hidden = YES;
        self.textField.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:14];
        self.textField.alignment = NSTextAlignmentCenter;
    } else  {
        self.cardBox.hidden = NO;
        self.textField.font = [NSFont fontWithName:@"IBMPlexSans-Text" size:12];
        self.textField.alignment = NSTextAlignmentLeft;
    }

}

@end
