//
//  SDWCheckItemTableCellView.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AAPLCheckBox.h"

@interface SDWCheckItemTableCellView : NSTableCellView

@property (strong) IBOutlet AAPLCheckBox *checkBox;
@property (strong) IBOutlet NSLayoutConstraint *centerYConstraint;

@end
