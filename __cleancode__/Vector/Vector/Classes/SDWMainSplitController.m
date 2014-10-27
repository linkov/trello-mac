//
//  SDWMainSplitController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWBoardsController.h"
#import "SDWBoard.h"
#import "SDWCard.h"
#import "AFRecordPathManager.h"
#import "SDWMainSplitController.h"

@interface SDWMainSplitController ()
@property (strong) IBOutlet NSSplitViewItem *boardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *cardsSplitItem;
@property (strong) IBOutlet NSSplitViewItem *inspectorSplitItem;

@end

@implementation SDWMainSplitController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWBoard class]
     toConcretePath:@"member/alexlink2/boards?key=6825229a76db5b6a5737eb97e9c4a923&token=19b58b73689c960cff5a07ceb0d9e3f848207e53059e892af1cadcbeb0174592&fields=name&lists=open"];

    SDWBoardsController *boardsVC = [self.storyboard instantiateControllerWithIdentifier:@"boardsVC"];
    self.cardsVC = [self.storyboard instantiateControllerWithIdentifier:@"cardsVC"];
    self.inspectorVC = [self.storyboard instantiateControllerWithIdentifier:@"singleCardVC"];

    self.boardsSplitItem = [NSSplitViewItem new];
    [self.boardsSplitItem setViewController:boardsVC];
    self.boardsSplitItem.holdingPriority = NSLayoutPriorityDefaultLow;

    self.cardsSplitItem = [NSSplitViewItem new];
    [self.cardsSplitItem setViewController:self.cardsVC];
    self.cardsSplitItem.holdingPriority = NSLayoutPriorityRequired;

    self.inspectorSplitItem = [NSSplitViewItem new];
    [self.inspectorSplitItem setViewController:self.inspectorVC];
    self.inspectorSplitItem.collapsed = YES;



    [self addSplitViewItem:self.boardsSplitItem];
    [self addSplitViewItem:self.cardsSplitItem];
    [self addSplitViewItem:self.inspectorSplitItem];

   // self.firstSplitItem = [self splitViewItemForViewController:boardsVC];

}

//- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
//
//
//}

@end
