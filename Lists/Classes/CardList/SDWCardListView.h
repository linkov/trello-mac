//
//  SDWCardListView.h
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWCardListView : NSBox

@property (strong) IBOutlet NSTextField *textField;

@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic,assign) BOOL hasDot;
@property (nonatomic,assign) BOOL shouldDrawSideLine;
@property (nonatomic,assign) BOOL shouldDrawSideLineAmber;
@property (nonatomic,strong) NSArray *labels;

@end
