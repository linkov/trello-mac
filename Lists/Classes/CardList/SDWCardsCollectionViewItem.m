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
}

- (void)viewDidAppear {
     [self loadCardUsers];
    [self markDescription];
    [self markDue];
}

- (void)markDue {
    NSDate *due = [self.representedObject valueForKey:@"dueDate"];

   // NSInteger time = [due timeIntervalSinceNow];

   // NSLog(@"time interval for %@ is %li",[self.representedObject valueForKey:@"name"],(long)time);

    if (due != nil && [due timeIntervalSinceNow] < 0.0) {

        for (id view in [self view].subviews) {

            if ([view isKindOfClass:[SDWCardListView class]]) {

                [(SDWCardListView *)view setShouldDrawSideLine:YES];
            }
        }
    } else if (due != nil && ([due timeIntervalSinceNow] > 0.0 && [due timeIntervalSinceNow] < 100000 ) ) {

        for (id view in [self view].subviews) {

            if ([view isKindOfClass:[SDWCardListView class]]) {

                [(SDWCardListView *)view setShouldDrawSideLineAmber:YES];
            }
        }
    }

}

- (void)markDescription {

    NSString *descString = [self.representedObject valueForKey:@"cardDescription"];
  //  NSLog(@"desc - %@",descString);

    if (descString.length > 0) {

        for (id view in [self view].subviews) {

            if ([view isKindOfClass:[SDWCardListView class]]) {

                [(SDWCardListView *)view setHasDescription:YES];
            }
        }
    }


}

- (void)loadCardUsers {

    self.shouldUseInitials = YES;

    //TODO: why here everything from XIB is nil if accessed directly ?
    NSStackView *stack;

    for (id theview in [self view].subviews) {

        for (id view1 in [(NSView *)theview subviews]) {

            for (id view2 in [(NSView *)view1 subviews]) {

                if ([view2 isKindOfClass:[NSStackView class]]) {

                    stack = (NSStackView *)view2;
                }
            }

        }
    }

    [stack.views makeObjectsPerformSelector:@selector(removeFromSuperview)];

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
            [stack addView:text inGravity:NSStackViewGravityTrailing];
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

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        self.textField.editable = YES;
        [self.textField becomeFirstResponder];
        [NSApplication.sharedApplication sendAction:@selector(collectionItemViewDoubleClick:) to:nil from:self];
       // [self.delegate cardViewDidReceiveDoubleClick:self];
    } else if (theEvent.clickCount == 1) {
        self.textField.editable = NO;
        [NSApplication.sharedApplication sendAction:@selector(collectionItemViewClick:) to:nil from:self];
    }

}

- (void)updateIndicators {
    [self markDescription];
    [self markDue];
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
