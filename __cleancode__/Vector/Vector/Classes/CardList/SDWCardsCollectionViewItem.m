//
//  SDWCardsCollectionViewItem.m
//  Vector
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
}

- (void)loadCardUsers {

    self.shouldUseInitials = YES;

    //TODO: why here everything from XIB is nil if accessed directly ?
    NSStackView *stack;

    for (id theview in [self view].subviews) {

        NSLog(@"- %@",theview);
        for (id view1 in [(NSView *)theview subviews]) {

            NSLog(@"- %@",theview);
            for (id view2 in [(NSView *)view1 subviews]) {

                NSLog(@"-- %@",view2);
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

//- (void)keyDown:(NSEvent *)theEvent {
//[super keyDown:theEvent];
//
//    NSLog(@"key = %i",theEvent.keyCode);
//
//
//    if (self.textField.editable) {
//
//    }
//}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {

    NSTextField* tf = (NSTextField*)control;
    
    self.originalText = tf.stringValue;
    return YES;
}
- (void)controlTextDidEndEditing:(NSNotification *)obj {

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
    }
    else {
        self.textField.editable = NO;
    }
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
