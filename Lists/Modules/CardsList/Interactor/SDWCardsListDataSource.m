//
//  SDWCardsListDataSource.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListDataSource.h"

@interface SDWCardsListDataSource ()

@property NSArray *items;
@property (copy) SDWCellConfigureBlock cellConfigureBlock;

@end

@implementation SDWCardsListDataSource

- (instancetype)initWithItems:(NSArray *)items configureBlock:(SDWCellConfigureBlock)configureBlock {
    self = [super init];
    if (self) {
        self.items = items;
        self.cellConfigureBlock = configureBlock;
    }

    return self;
}

//Number of rows in section
- (NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

//Number of sections
- (NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
    return 1;
}

//Has a header view for a section
- (BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
    return NO;
}

//Height related
- (CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {
    return 0;
}

//View related
- (NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    NSTableCellView *cell = self.cellConfigureBlock(item);

    return cell;
}

#pragma mark - Utils

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger)indexPath.row];
}

@end
