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

@end

@implementation SDWMainSplitController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWBoard class]
     toConcretePath:@"member/alexlink2/boards?key=6825229a76db5b6a5737eb97e9c4a923&token=19b58b73689c960cff5a07ceb0d9e3f848207e53059e892af1cadcbeb0174592&fields=name&lists=open"];


    [self addChildViewController:[self.storyboard instantiateControllerWithIdentifier:@"boardsVC"]];
    [self addChildViewController:[self.storyboard instantiateControllerWithIdentifier:@"cardsVC"]];
    [self addChildViewController:[self.storyboard instantiateControllerWithIdentifier:@"singleCardVC"]];

}


@end
