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

@interface SDWSingleCardTableCellView ()

@property (strong) NSString *originalText;

@end

@implementation SDWSingleCardTableCellView


#pragma mark - Mouse

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {

        self.mainBox.textField.editable = YES;
        [self.mainBox.textField becomeFirstResponder];

    } else if (theEvent.clickCount == 1) {
        self.mainBox.textField.editable = NO;
    }
    
}

- (void)rightMouseDown:(NSEvent *)theEvent {

    if (SharedSettings.shouldShowCardLabels == NO) {
        return;
    }

    [self.delegate cardViewDidSelectCard:self];

    NSMenu *labelsMenu = [Utils labelsMenu];

    for (NSMenuItem *item in labelsMenu.itemArray) {

        [item setTarget:self];
        [item setAction:@selector(changeCardLabel:)];
        item.state = [self isActiveLabelWithTitle:item.title] ? 1 : 0;

    }

    [NSMenu popUpContextMenu:labelsMenu withEvent:theEvent forView:self];
    
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

    self.mainBox.textField.editable = NO;

    if (self.mainBox.textField.stringValue.length == 0) {
         [self.delegate cardViewShouldDismissCard:self];
    }

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {

    if (![self.originalText isEqualToString:self.textField.stringValue]) {

        [self.delegate cardViewShouldSaveCard:self];
        [self.mainBox.textField resignFirstResponder];
        self.mainBox.textField.editable = NO;
    }
    
    return YES;
}

#pragma mark - Card labels

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
