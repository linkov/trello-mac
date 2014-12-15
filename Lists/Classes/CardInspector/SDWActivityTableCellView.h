//
//  SDWActivityTableCellView.h
//  Lists
//
//  Created by alex on 12/16/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWActivityTableCellView : NSTableCellView
@property (strong) IBOutlet NSTextField *initialsLabel;
@property (strong) IBOutlet NSTextField *timeLabel;
@property (strong) IBOutlet NSBox *separatorLine;

@end
