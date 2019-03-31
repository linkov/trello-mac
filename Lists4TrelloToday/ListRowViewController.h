//
//  ListRowViewController.h
//  Lists4TrelloToday
//
//  Created by Alex Linkov on 3/31/19.
//  Copyright © 2019 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ListRowViewController : NSViewController

@property (strong) IBOutlet NSTextField *textField;
@property (strong) IBOutlet NSBox *cardBox;

@property (strong) NSString *taskName;
@property  bool isHeaderRow;

@end
