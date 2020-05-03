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

#import "SDWLabelDisplayItem.h"
#import "SDWUserDisplayItem.h"
#import "SDWCardDisplayItem.h"
#import "SDWBoardDisplayItem.h"

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

    if (!self.menuClickEnabled) {
         return;
    }
    
   
    
    [self.delegate cardViewDidSelectCard:self];

    
    
    NSMenu *labelsMenu = [Utils labelsMenuForBoard:self.boardID];
    

    for (NSMenuItem *item in labelsMenu.itemArray) {

        [item setTarget:self];
        
        if (item.image) {
            [item setAction:@selector(changeCardLabel:)];
            item.state = [self labelActiveWitItemName:item.title] ? 1 : 0;
        } else {
            

            [item setAction:@selector(changeUser:)];
            item.state = [self labelActiveWitUserName:item.title] ? 1 : 0;
        }
        

        

        
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
    
    if (![self.originalText isEqualToString:self.textField.stringValue]) {
        
        [self.delegate cardViewShouldSaveCard:self];
        [self.mainBox.textField resignFirstResponder];
        self.mainBox.textField.editable = NO;
    }
    

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    


    return YES;
}

#pragma mark - Card labels


- (void)changeUser:(NSMenuItem *)sender {
    
    SDWBoardDisplayItem *board = self.cardDisplayItem.board;
   SDWUserDisplayItem *selectedUser = [[[board members] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"initials == %@",sender.title]] firstObject];
    if ([self labelActiveWitUserName:sender.title]) {
        [self.delegate cardViewShouldRemoveUser:selectedUser.trelloID];
    } else {
        [self.delegate cardViewShouldAddUser:selectedUser.trelloID];
    }

//    self.mainBox.labels = modifiedLabels;
    //[self loadCardUsers];
    
}

- (void)changeCardLabel:(NSMenuItem *)sender {

    NSMutableArray *modifiedLabels = [NSMutableArray arrayWithArray:self.mainBox.labels];
    SDWLabelDisplayItem *selectedLabel = [[self.mainBox.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@ || color == %@",sender.title, sender.title]] firstObject];
    SDWLabelDisplayItem *newLabel = [SDWLabelDisplayItem new];
    newLabel.color = sender.title;


    if ([self labelActiveWitItemName:sender.title]) {

        [modifiedLabels removeObject:selectedLabel];
        [self.delegate cardViewShouldRemoveLabelOfColor:sender.title];
    } else {
        [modifiedLabels addObject:newLabel];
        [self.delegate cardViewShouldAddLabelOfColor:sender.title];
    }

    self.mainBox.labels = modifiedLabels;
    //[self loadCardUsers];
    
}

- (BOOL)labelActiveWitItemName:(NSString *)name {

    NSUInteger count =  [[self.cardDisplayItem.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@ || color == %@",name, name]] count];

    return count > 0;
}

- (BOOL)labelActiveWitUserName:(NSString *)name {

    NSUInteger count =  [[self.cardDisplayItem.members filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"initials == %@",name]] count];

    return count > 0;
}


//- (BOOL)isActiveLabelWithTitle:(NSString *)title {
//
//    NSUInteger count =  [[self.mainBox.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@",title]] count];
//
//    return count > 0;
//}

@end
