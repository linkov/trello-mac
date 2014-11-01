//
//  SDWCardListView.h
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWCardListView : NSBox

@property (strong) IBOutlet NSColor *IBfillColor;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (IBAction)setCRRR:(id)sender;

@end
