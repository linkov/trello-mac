//
//  SDWCardsCollectionViewItem.m
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "NSView+Utils.h"
#import "SDWUser.h"
#import "SDWAppSettings.h"
#import "SDWCardListView.h"
#import "SDWCardsCollectionViewItem.h"
#import "Utils.h"
#import "SDWLabel.h"

@interface SDWCardsCollectionViewItem () <NSTextFieldDelegate>

@property BOOL shouldUseInitials;
@property (strong) NSArray *loadedUsers;
@property (strong) IBOutlet NSTextField *textField;
@property (strong) NSString *originalText;

@end

@implementation SDWCardsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainBox.cornerRadius = 1.5;
    self.textField.editable = NO;
    self.textField.delegate = self;

    NSLog(@" viewDidLoad mainBox - %@",self.mainBox);
}

//TODO:refactor
- (void)restoreStack {

    for (id theview in [self view].subviews) {

        for (id view1 in [(NSView *)theview subviews]) {

            for (id view2 in [(NSView *)view1 subviews]) {

                if ([view2 isKindOfClass:[NSStackView class]]) {

                    self.stackView = (NSStackView *)view2;
                }
            }
            
        }
    }
}

- (void)restoreMainbox {

    for (id view in [self view].subviews) {

        if ([view isKindOfClass:[SDWCardListView class]]) {

            self.mainBox = view;
        }
    }
}

- (void)viewDidAppear {
    [self restoreMainbox];
    [self restoreStack];
    [self markDot];
    [self markDue];
    [self markLabels];
    [self loadCardUsers];

    NSLog(@" viewDidAppear mainBox - %@", self.mainBox);
}

- (void)markLabels {

    if (SharedSettings.shouldShowCardLabels == YES) {
        self.mainBox.labels = [self.representedObject valueForKey:@"labels"];
    } else {
        self.mainBox.labels = @[];
    }
}

- (void)markDue {
    NSDate *due = [self.representedObject valueForKey:@"dueDate"];

   // NSInteger time = [due timeIntervalSinceNow];

   // NSLog(@"time interval for %@ is %li",[self.representedObject valueForKey:@"name"],(long)time);

    if (due != nil && [due timeIntervalSinceNow] < 0.0) {

        [self.mainBox setShouldDrawSideLine:YES];

    } else if (due != nil && ([due timeIntervalSinceNow] > 0.0 && [due timeIntervalSinceNow] < 100000 ) ) {

        [self.mainBox setShouldDrawSideLineAmber:YES];
    }

}

- (void)markDot {

    switch (SharedSettings.dotOption) {
            
        case SDWDotOptionHasDescription: {

            NSString *descString = [self.representedObject valueForKey:@"cardDescription"];
            //  NSLog(@"desc - %@",descString);

            if (descString.length > 0) {

                [self.mainBox setHasDot:YES];
            }

        }

            break;
        case SDWDotOptionNoDue: {

            NSDate *due = [self.representedObject valueForKey:@"dueDate"];
           //   NSLog(@"due - %@",due);

            if (due == nil) {

                [self.mainBox setHasDot:YES];
            }
        }

            break;

        case SDWDotOptionOff: {
            
        }

            break;

        default:
            break;
    }

}

- (void)loadCardUsers {

    self.shouldUseInitials = YES;

    [self.stackView.views makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray *members = [self.representedObject valueForKey:@"members"];

    for (NSString *memberID in members) {

        NSTextField *text = [[NSTextField alloc]init];

        [text setWantsLayer:YES];
        [text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text setFont:[NSFont systemFontOfSize:9]];
        [text setTextColor:[NSColor colorWithHexColorString:@"3E6378"]];
        [text setStringValue:[self memberNameFromID:memberID] ];
        [text setEditable:NO];
        text.alignment = NSCenterTextAlignment;

        text.layer.cornerRadius = 1.5;
        text.layer.borderWidth = 1;
        text.layer.borderColor = [NSColor colorWithHexColorString:@"3E6378"].CGColor;

        if (text.stringValue.length >0) {

            if (self.mainBox.labels.count == 0) {

                //TODO: remove this hack
                for (NSLayoutConstraint *co in self.mainBox.constraints) {
                    if (co.constant == 5 && co.priority == 750) {
                        co.constant = 8;
                    }
                }
            }


            [self.stackView addView:text inGravity:NSStackViewGravityTrailing];
        }
    }

}

- (void)setSelected:(BOOL)selected {

    if (self.selected && !selected) {
        [self.delegate cardViewShouldDeselectCard:self];
    }

    [super setSelected:selected];


    if (selected) {
        self.textColor = [NSColor blackColor];
        [self.delegate cardViewDidSelectCard:self];

    }
    else {
        self.textColor = [NSColor blackColor];
    }

    for (id view in [self view].subviews) {

        if ([view isKindOfClass:[SDWCardListView class]]) {

            [(SDWCardListView *)view setSelected:selected];
        }
    }
}

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

- (void)rightMouseDown:(NSEvent *)theEvent {

    if (SharedSettings.shouldShowCardLabels == NO) {
        return;
    }

    self.selected = YES;

    NSMenu *labelsMenu = [Utils labelsMenu];

    for (NSMenuItem *item in labelsMenu.itemArray) {

        [item setTarget:self];
        [item setAction:@selector(changeCardLabel:)];
        item.state = [self isActiveLabelWithTitle:item.title] ? 1 : 0;

    }

    [NSMenu popUpContextMenu:labelsMenu withEvent:theEvent forView:self.view];

}

- (BOOL)isActiveLabelWithTitle:(NSString *)title {

   NSUInteger count =  [[self.mainBox.labels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"color == %@",title]] count];

   return count > 0;
}


- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        self.textField.editable = YES;
        [self.textField becomeFirstResponder];
       // [self.delegate cardViewDidReceiveDoubleClick:self];
    } else if (theEvent.clickCount == 1) {
        self.textField.editable = NO;
    }

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
    [self loadCardUsers];

}


- (void)viewDidLayout {
    [super viewDidLayout];
}

- (NSString *)memberNameFromID:(NSString *)userID {

    for (SDWUser *user in SharedSettings.selectedListUsers) {

        if ([user.userID isEqualToString:userID]) {

            NSString *str = self.shouldUseInitials ? [Utils twoLetterIDFromName:user.name] : user.name;


            return str;
        }
    }
    return @"nope";
}


@end
