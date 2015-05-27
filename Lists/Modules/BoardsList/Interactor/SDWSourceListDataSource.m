//
//  SDWSourceListDataSource.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSourceListDataSource.h"
#import "SDWSourceListItem.h"

@interface SDWSourceListDataSource () <NSOutlineViewDataSource>

@property NSArray *items;

@end

@implementation SDWSourceListDataSource

- (instancetype)initWithItems:(NSArray *)items {

    self = [super init];
    if (self) {

        self.items = items;
    }
    return self;
}


- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id<SDWSourceListItem>)item {


    if (![item children]) {
        return self.items.count;
    }

    return [item children].count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id<SDWSourceListItem>)item {

    if (![item children]) {
        return [self.items objectAtIndex:index];
    }

    return [item childAtIndex:index];

}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id<SDWSourceListItem>)item {

    return ![item isLeaf];

}


@end
