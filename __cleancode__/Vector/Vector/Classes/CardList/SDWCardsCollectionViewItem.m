//
//  SDWCardsCollectionViewItem.m
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSView+Utils.h"
#import "SDWUser.h"
#import "SDWAppSettings.h"
#import "SDWCardListView.h"
#import "SDWCardsCollectionViewItem.h"

@interface SDWCardsCollectionViewItem ()

@property BOOL shouldUseInitials;

@end

@implementation SDWCardsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainBox.cornerRadius = 3;

    //self.stackView.delegate = self;

//    NSTextField *text = [[NSTextField alloc]init];
//    [text setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [text setFont:[NSFont systemFontOfSize:9]];
//    [text setStringValue:@"AL"];
//    [text setEditable:NO];
//
//    NSTextField *text1 = [[NSTextField alloc]init];
//    [text1 setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [text1 setFont:[NSFont systemFontOfSize:9]];
//    [text1 setStringValue:@"TC"];
//    [text1 setEditable:NO];
//  //  text1.
//
//
//    [self.stackView addView:text inGravity:NSStackViewGravityTrailing];
//    [self.stackView addView:text1 inGravity:NSStackViewGravityTrailing];
//
    NSShadow *bottomCardShadow = [NSShadow new];
    bottomCardShadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.75];
    bottomCardShadow.shadowBlurRadius = 0.2;
    bottomCardShadow.shadowOffset = NSMakeSize(0,-0.2);
    [self.mainBox setShadow:bottomCardShadow];

//    NSShadow *shadow = [[NSShadow alloc] init];
//    [shadow setShadowBlurRadius:3.0];
//    [shadow setShadowOffset:NSMakeSize(0.0, 5.0)];
//    [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.6]];
//
//    [self.mainBox setShadow:shadow];

//    NSShadow *bottomCardShadow = [NSShadow setShadowWithOffset:NSMakeSize(0, -8 * 1.0) blurRadius:12 * 1.0
//                            color:[NSColor colorWithCalibratedWhite:0 alpha:0.75]];
//
//    self.mainBox.shadow = bottomCardShadow;


//    NSView *box = self.mainBox;
//    NSArray *conss = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[box]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
//    [self.view addConstraints:conss];
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
//
//    [[self mainBox] setSelected:selected];


    for (id view in [self view].subviews) {

        if ([view isKindOfClass:[SDWCardListView class]]) {

            [(SDWCardListView *)view setSelected:selected];
        }
       // NSLog(@"available view = %@",view);
    }

   // [(SDWCardListView *)[self mainBox] setSelected:selected];
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

- (void)viewDidAppear {

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


    NSArray *members = [self.representedObject valueForKey:@"members"];

    for (NSString *memberID in members) {

        NSTextField *text1 = [[NSTextField alloc]init];
        [text1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text1 setFont:[NSFont systemFontOfSize:9]];
        [text1 setStringValue:[self memberNameFromID:memberID] ];
        [text1 setEditable:NO];
       // [text1 insertVibrancyViewBlendingMode:NSVisualEffectBlendingModeBehindWindow];
        //  text1.

        [stack addView:text1 inGravity:NSStackViewGravityTrailing];
    }

//    NSLog(@"%@",[self.representedObject valueForKey:@"name"]);
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
