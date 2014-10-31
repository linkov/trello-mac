//
//  SDWCardsCollectionViewItem.m
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWCardsCollectionViewItem.h"

@interface SDWCardsCollectionViewItem ()
@property (strong) IBOutlet NSBox *mainBox;

@end

@implementation SDWCardsCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainBox.cornerRadius = 6;
    self.mainBox.borderWidth = 4;
}

@end
