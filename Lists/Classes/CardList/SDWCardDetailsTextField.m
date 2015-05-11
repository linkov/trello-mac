//
//  SDWCardListTextField.m
//  Lists
//
//  Created by alex on 11/11/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCardDetailsTextField.h"

@interface SDWCardDetailsTextField ()

@property (strong) NSFont *origFont;

@end

@implementation SDWCardDetailsTextField

- (void)awakeFromNib {
    self.wantsLayer = YES;
    self.backgroundColor = [NSColor clearColor];
}

//- (void)selectLine:(id)sender {
//
//
//}
//
//- (void)selectText:(id)sender {
//
//
//}

- (void)mouseDown:(NSEvent *)theEvent {
    NSTextField *textField = self;
    NSColor *insertionPointColor = [NSColor whiteColor];

    NSTextView *fieldEditor = (NSTextView *)[textField.window fieldEditor:YES
                                                                forObject:textField];
    fieldEditor.insertionPointColor = insertionPointColor;

//    self.origFont = self.font;
//    self.font = [NSFont boldSystemFontOfSize:12];
}

//- (void)textDidEndEditing:(NSNotification *)notification {
//
//    [super textDidEndEditing:notification];
//}

@end
