//
//  SDWSingleCardTableCellView.m
//  Lists
//
//  Created by alex on 2/11/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSingleCardTableCellView.h"
#import "SDWCardListView.h"
#import "Utils.h"
#import "SDWLabel.h"

@interface SDWSingleCardTableCellView () <NSTextFieldDelegate>

@property (strong) NSString *originalText;

@end

@implementation SDWSingleCardTableCellView

- (void)awakeFromNib {

    self.textField.editable = NO;
    self.textField.delegate = self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        self.textField.editable = YES;
        [self.textField becomeFirstResponder];

    } else if (theEvent.clickCount == 1) {
        self.textField.editable = NO;
    }
    
}

#pragma mark - NSTextFieldDelegate

- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {

    return nil;
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {

    NSTextField* tf = (NSTextField*)control;

    self.originalText = tf.stringValue;
    return YES;
}

- (void)controlTextDidChange:(NSNotification *)obj {}


- (void)controlTextDidEndEditing:(NSNotification *)obj {

    self.textField.editable = NO;

    if (self.textField.stringValue.length == 0) {
        [self.delegate cardViewShouldDismissCard:self];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {

    if (![self.originalText isEqualToString:self.textField.stringValue]) {
        [self.delegate cardViewShouldSaveCard:self];
        [self.textField resignFirstResponder];
        self.textField.editable = NO;
    }
    
    return YES;
}

#pragma mark - Labels

- (void)rightMouseDown:(NSEvent *)theEvent {

    if (SharedSettings.shouldShowCardLabels == NO) {
        return;
    }

    //self.selected = YES;

    NSMenu *labelsMenu = [Utils labelsMenu];

    for (NSMenuItem *item in labelsMenu.itemArray) {

        [item setTarget:self];
        [item setAction:@selector(changeCardLabel:)];
        item.state = [self isActiveLabelWithTitle:item.title] ? 1 : 0;

    }

    [NSMenu popUpContextMenu:labelsMenu withEvent:theEvent forView:self];
    
}

- (void)changeCardLabel:(NSMenuItem *)sender {

    NSMutableArray *modifiedLabels = [NSMutableArray arrayWithArray:self.mainBox.labels];
    SDWLabel *selectedLabel = [[self.mainBox.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@",sender.title]] firstObject];
    SDWLabel *newLabel = [SDWLabel new];
    newLabel.color = sender.title;


    if ([self isActiveLabelWithTitle:sender.title]) {

        [modifiedLabels removeObject:selectedLabel];
        [self.delegate cardViewShouldRemoveLabelOfColor:sender.title];
    } else {
        [modifiedLabels addObject:newLabel];
        [self.delegate cardViewShouldContainLabelColors:[[modifiedLabels valueForKeyPath:@"color"] componentsJoinedByString:@","]];
    }

    self.mainBox.labels = modifiedLabels;
    //[self loadCardUsers];
    
}


- (BOOL)isActiveLabelWithTitle:(NSString *)title {

    NSUInteger count =  [[self.mainBox.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@",title]] count];

    return count > 0;
}

@end
