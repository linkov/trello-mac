//
//  SDWCardsListDataSource.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListDataSource.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/

/*-------Models-------*/
#import "SDWCardManaged.h"

#define kMinimumCellHeight 28

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

//- (CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kMinimumCellHeight;
//}

- (CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDWCardManaged *card = self.items[indexPath.row];

    CGRect rec = [card.name boundingRectWithSize:CGSizeMake(380, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:11]}];
    CGFloat height = ceilf(rec.size.height);

    if (height > 14) {
        return height + 7 + 7;
    }

    return 28;
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
