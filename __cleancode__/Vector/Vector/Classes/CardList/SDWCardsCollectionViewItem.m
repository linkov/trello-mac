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

@interface SDWCardsCollectionViewItem ()

@property BOOL shouldUseInitials;
@property (strong) NSArray *loadedUsers;

@end

@implementation SDWCardsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainBox.cornerRadius = 1.5;

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

- (void)setSelected:(BOOL)selected
{

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


-(void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2)
    {
        [NSApplication.sharedApplication sendAction:@selector(collectionItemViewDoubleClick:) to:nil from:self];
    }
}

- (void)viewDidLayout {

    [super viewDidLayout];
    
}


- (NSString *)memberNameFromID:(NSString *)userID{

    for (SDWUser *user in SharedSettings.selectedListUsers) {

        if ([user.userID isEqualToString:userID]) {

            NSString *str = self.shouldUseInitials ? [self twoLetterIDFromName:user.name] : user.name;


            return str;
        }
    }
    return @"nope";
}

- (NSString *)twoLetterIDFromName:(NSString *)name {

    NSString *finalString;

    NSArray *nameArr = [name componentsSeparatedByString:@" "];

    NSString *firstName = nameArr[0];

    if (nameArr.count>1) {

        NSString *lastName = nameArr[1];

        NSMutableArray *firstNameArr = [NSMutableArray new];

        [firstName enumerateSubstringsInRange: NSMakeRange(0,firstName.length)
                                      options: NSStringEnumerationByComposedCharacterSequences
                                   usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                       // If you want to see the way the string has been split
                                       //NSLog(@"%@", substring);
                                       [firstNameArr addObject: substring];
                                   }
         ];

        NSMutableArray *lastNameArr = [NSMutableArray new];

        [lastName enumerateSubstringsInRange: NSMakeRange(0,firstName.length)
                                     options: NSStringEnumerationByComposedCharacterSequences
                                  usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                      // If you want to see the way the string has been split
                                      //NSLog(@"%@", substring);
                                      [lastNameArr addObject: substring];
                                  }
         ];

        finalString = [NSString stringWithFormat:@"%@%@",firstNameArr[0],lastNameArr[0]];
    }
    else {

        finalString = @"";
    }
    
    
    return [finalString uppercaseString];
}

- (void)expand {

//    NSView *box = (SDWCardListView *)[self view];
//
//
//    NSArray *conss = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(600@1000)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
//    NSArray *conss1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(250@1000)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(box)];
//
//    [self.view addConstraints:conss];
//    [self.view addConstraints:conss1];
//    [self.view setNeedsUpdateConstraints:YES];
//    [self.view updateConstraintsForSubtreeIfNeeded];
//    [self.view layoutSubtreeIfNeeded];

    //[(SDWCardListView *)[self view] expand];
}

@end
