//
//  CardsController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWUser.h"
#import "SDWcard.h"
#import "AFRecordPathManager.h"
#import "SDWCardsController.h"
#import "SDWCardsCollectionViewItem.h"
#import "SDWAppSettings.h"

@interface SDWCardsController () <NSCollectionViewDelegate>
@property (strong) IBOutlet NSArrayController *cardsArrayController;
@property (strong) IBOutlet NSCollectionView *collectionView;

@property (strong) NSArray *cards;
@property (strong) NSArray *storedUsers;
@property (strong) NSString *currentListID;

@end

@implementation SDWCardsController

- (void)viewDidLoad {
	[super viewDidLoad];


	self.collectionView.itemPrototype = [self.storyboard instantiateControllerWithIdentifier:@"collectionProto"];
    //[self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

//    NSView *box = self.collectionView;
//    NSArray *conssss = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[box]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(box)];
//        NSArray *conssss1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[box]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(box)];
//
//    [self.view addConstraints:conssss];
//    [self.view addConstraints:conssss1];

	//   [self.collectionView setBoundsOrigin:CGPointMake(-10, -10)];
 ///   NSSize minSize = NSMakeSize(0,0);
 ///   [self.collectionView setMaxItemSize:minSize];

}

- (void)viewWillAppear {
	[super viewWillAppear];
}

- (void)viewDidLayout {
	[super viewDidLayout];
}

- (void)setupCardsForList:(NSString *)listID parentListID:(NSString *)parentID {


    self.currentListID = listID;
    [self loadMembers:parentID];
}

- (void)loadMembers:(NSString *)listID {

    NSString *URL = [NSString stringWithFormat:@"boards/%@/members?", listID];
    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWUser class]
	    toConcretePath:URL];

    [self.loadingIndicator startAnimation:nil];

    [SDWUser findAll:^(NSArray *objs, NSError *err) {

        [self.loadingIndicator stopAnimation:nil];

        if (!err) {
            SharedSettings.selectedListUsers = objs;
            [self loadCardsForListID:self.currentListID];
        } else {
            NSLog(@"err = %@", err.localizedDescription);
        }
    }];

}

- (void)loadCardsForListID:(NSString *)listID {

    NSString *URL = [NSString stringWithFormat:@"lists/%@/cards", listID];
    NSString *URL2 = [NSString stringWithFormat:@"?lists=open&cards=open&card_fields=name,pos,idMembers,labels"];

    NSString *URLF = [NSString stringWithFormat:@"%@%@", URL, URL2];

    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWCard class]
	    toConcretePath:URLF];

    [self.loadingIndicator startAnimation:nil];

    [SDWCard findAll:^(NSArray *objs, NSError *err) {

        [self.loadingIndicator stopAnimation:nil];

        if (!err) {
            [self reloadCollection:objs];
        } else {
            NSLog(@"err = %@", err.localizedDescription);
        }
    }];
}

- (void)reloadCollection:(NSArray *)objects {

	self.cardsArrayController.content = objects;
    self.cards = objects;
}


#pragma mark - NSCollectionViewDelegate

- (void)collectionItemViewDoubleClick:(NSCollectionViewItem *)sender {



    NSLog(@"double clicked item = %@",sender);
    SDWCardsCollectionViewItem *selected =  (SDWCardsCollectionViewItem *)[self.collectionView itemAtIndex:self.collectionView.selectionIndexes.firstIndex];


    //[selected.view setTranslatesAutoresizingMaskIntoConstraints:NO];

//
    selected.view.frame = CGRectMake(selected.view.frame.origin.x, selected.view.frame.origin.y, selected.view.frame.size.width, 250);

    NSMutableArray *displayed =[self.collectionView valueForKeyPath:@"_displayedItems"];

    for (SDWCardsCollectionViewItem *row in displayed) {

        NSUInteger index = [displayed indexOfObject:row];
        if (index > self.collectionView.selectionIndexes.firstIndex) {

            row.view.frame =  CGRectMake(row.view.frame.origin.x, row.view.frame.origin.y+220, row.view.frame.size.width, row.view.frame.size.height);
        }
    }

//    NSView *box = selected.view;
//
//    NSArray *conss = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(600@1000)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
//    NSArray *conss1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(250@1000)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(box)];
//
//    [self.view addConstraints:conss];
//    [self.view addConstraints:conss1];
//    [self.view setNeedsUpdateConstraints:YES];
//    [self.view updateConstraintsForSubtreeIfNeeded];
//    [self.view layoutSubtreeIfNeeded];
//
//    [self.collectionView invalidateIntrinsicContentSize];
//
//    [self.collectionView updateConstraintsForSubtreeIfNeeded];
   // self.collectionView.content = self.cards;


   // [selected expand];

//   self.collectionView.content = self.cards;


}


@end
