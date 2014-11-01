//
//  CardsController.m
//  Vector
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWcard.h"
#import "AFRecordPathManager.h"
#import "SDWCardsController.h"

@interface SDWCardsController () <NSCollectionViewDelegate>
@property (strong) IBOutlet NSArrayController *cardsArrayController;
@property (strong) IBOutlet NSCollectionView *collectionView;

@property (strong) NSArray *cards;

@end

@implementation SDWCardsController

- (void)viewDidLoad {
	[super viewDidLoad];


	self.collectionView.itemPrototype = [self.storyboard instantiateControllerWithIdentifier:@"collectionProto"];
	//   [self.collectionView setBoundsOrigin:CGPointMake(-10, -10)];
}

- (void)viewWillAppear {
	[super viewWillAppear];
}

- (void)viewDidLayout {
	[super viewDidLayout];
}

- (void)setupCardsForList:(NSString *)listID {


	NSString *URL = [NSString stringWithFormat:@"lists/%@/cards", listID];
	NSString *URL2 = [NSString stringWithFormat:@"?lists=open&cards=open&card_fields=name,pos,idMembers,labels"];

	NSString *URLF = [NSString stringWithFormat:@"%@%@", URL, URL2];

	[[AFRecordPathManager manager]
	 setAFRecordMethod:@"findAll"
	          forModel:[SDWCard class]
	    toConcretePath:URLF];

	[SDWCard findAll:^(NSArray *objs, NSError *err) {

	    if (!err) {
	        [self reloadCollection:objs];
		} else {
	        NSLog(@"err = %@", err.localizedDescription);
		}
	}];
}

- (void)reloadCollection:(NSArray *)objects {

	self.cardsArrayController.content = objects;
}


#pragma mark - NSCollectionViewDelegate

- (void)collectionItemViewDoubleClick:(id)sender {


}


@end
