//
//  SDWCardsListDelegate.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListDelegate.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/
#import "SDWCardsListRow.h"

/*-------Helpers & Managers-------*/
#import "Constants.h"
#import "SDWMacros.h"

/*-------Models-------*/
#import "SDWCardManaged.h"

@interface SDWCardsListDelegate ()

@property NSArray *items;
@property NSUInteger dropIndex;
@property (copy) SDWCellReorderBlock reorderBlock;

@end

@implementation SDWCardsListDelegate

- (instancetype)initWithItems:(NSArray *)items
                 reorderBlock:(SDWCellReorderBlock)block {
    self = [super init];
    if (self) {
        self.items = items;
        self.reorderBlock = block;
    }

    return self;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    SDWCardsListRow *rowView = [SDWCardsListRow new];

    return rowView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {
    return YES;
}

#pragma mark - Drag & Drop

- (BOOL)_jwcTableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    SDWCardManaged *card = self.items[rowIndexes.firstIndex];
    NSDictionary *dataDict = @{
        @"cardID": card.listsID,
        @"itemIndex": [NSNumber numberWithInteger:rowIndexes.firstIndex]
    };

    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
    [pboard setData:indexData forType:SDWListsCardsListDragedTypesReorder];

    return YES;
}

- (NSDragOperation)_jwcTableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    if (self.items.count == 1) {
        return NSDragOperationNone;
    }

    NSDragOperation dragOp = NSDragOperationNone;

    if (op == NSTableViewDropAbove) {
        dragOp = NSDragOperationMove;
    } else if (op == NSTableViewDropOn) {
        dragOp = NSDragOperationNone;

        NSUInteger inx = row;
        self.dropIndex = inx;
    }

    return dragOp;
}

- (BOOL)_jwcTableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
                  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    if (self.dropIndex > self.items.count) {
        return NO;
    }

    NSPasteboard *pBoard = [info draggingPasteboard];
    NSData *data = [pBoard dataForType:SDWListsCardsListDragedTypesReorder];

    if (!data) {
        return NO;
    }

    NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSUInteger itemMovedFromIndex = [dataDict[@"itemIndex"] integerValue];

    SDWPerformBlock(self.reorderBlock, itemMovedFromIndex, self.dropIndex, [NSArray arrayWithArray:self.items]);

    return YES;
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
}

@end
