//
//  SDWCardsCollectionViewItem.m
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWCardListView.h"
#import "SDWCardsCollectionViewItem.h"

@interface SDWCardsCollectionViewItem ()


@end

@implementation SDWCardsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainBox.cornerRadius = 3;

    //self.stackView.delegate = self;

    NSTextField *text = [[NSTextField alloc]init];
    [text setTranslatesAutoresizingMaskIntoConstraints:NO];
    [text setFont:[NSFont systemFontOfSize:8]];
    [text setStringValue:@"AL"];
    [text setEditable:NO];

    NSTextField *text1 = [[NSTextField alloc]init];
    [text1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [text1 setFont:[NSFont systemFontOfSize:8]];
    [text1 setStringValue:@"TC"];
    [text1 setEditable:NO];
  //  text1.


    [self.stackView addView:text inGravity:NSStackViewGravityTrailing];
    [self.stackView addView:text1 inGravity:NSStackViewGravityTrailing];

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
