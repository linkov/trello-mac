//
//  SDWCardsListCell.m
//  Lists
//
//  Created by alex on 5/30/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListCell.h"
#import "SDWMacros.h"

@interface SDWCardsListCell () <NSTextFieldDelegate>

@property NSString *originalText;

@end

@implementation SDWCardsListCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (void)setSelected:(BOOL)isSelected {
    if (isSelected) {
        [self.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
    } else {
        [self.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    }
}

- (void)awakeFromNib {
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    self.layer.cornerRadius = 1.5;
    self.layer.masksToBounds = YES;
    self.textField.delegate = self;
}

#pragma mark - Actions

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        self.textField.editable = YES;
        [self.textField becomeFirstResponder];
    } else if (theEvent.clickCount == 1) {
        self.textField.editable = NO;
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {

    SDWPerformBlock(self.rightClickBlock);

}

#pragma mark - NSTextFieldDelegate

- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    return nil;
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    NSTextField *tf = (NSTextField *)control;

    self.originalText = tf.stringValue;
    return YES;
}

- (void)controlTextDidChange:(NSNotification *)obj {
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    self.textField.editable = NO;

    if (self.textField.stringValue.length == 0) {
       // [self.delegate cardViewShouldDismissCard:self];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if (![self.originalText isEqualToString:self.textField.stringValue]) {
        [self.textField resignFirstResponder];
        self.textField.editable = NO;
        SDWPerformBlock(self.returnBlock);
    }

    return YES;
}


#pragma mark - Utils

+ (NSNib *)nib {
    return [[NSNib alloc]initWithNibNamed:@"SDWCardsListCell" bundle:nil];
}

@end
