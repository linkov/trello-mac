//
//  SDWAddNamedItemTextField.m
//  Lists
//
//  Created by alex on 8/31/16.
//  Copyright © 2016 SDWR. All rights reserved.
//

#import "SDWAddNamedItemTextField.h"

@implementation SDWAddNamedItemTextField


- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    NSTextField *textField = self;
    NSColor *insertionPointColor = [NSColor whiteColor];

    NSTextView *fieldEditor = (NSTextView*)[textField.window fieldEditor:YES
                                                               forObject:textField];
    fieldEditor.insertionPointColor = insertionPointColor;

    self.editable = YES;
    [self becomeFirstResponder];
    
}


@end
