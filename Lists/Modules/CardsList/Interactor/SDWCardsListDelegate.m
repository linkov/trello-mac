//
//  SDWCardsListDelegate.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListDelegate.h"

@interface SDWCardsListDelegate ()

@property NSArray *items;

@end

@implementation SDWCardsListDelegate

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = items;
    }

    return self;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
}

- (NSString *)tableView:(NSTableView *)tableView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    return nil;
}

/*  Optional - Custom tracking support
   It is possible to control the ability to track a cell or not. Normally, only selectable or selected cells can be tracked. If you implement this method, cells which are not selectable or selected can be tracked, and vice-versa. For instance, this allows you to have an NSButtonCell in a table which does not change the selection, but can still be clicked on and tracked.
 */
- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return NO;
}

/*  Optional - Different cells for each row
   A different data cell can be returned for any particular tableColumn and row, or a cell that will be used for the entire row (a full width cell). The returned cell should properly implement copyWithZone:, since the cell may be copied by NSTableView. If the tableColumn is non-nil, and nil is returned, then the table will use the default cell from [tableColumn dataCellForRow:row].

   When each row is being drawn, this method will first be called with a nil tableColumn. At this time, you can return a cell that will be used to draw the entire row, acting like a group. If you do return a cell for the 'nil' tableColumn, be prepared to have the other corresponding datasource and delegate methods to be called with a 'nil' tableColumn value. If don't return a cell, the method will be called once for each tableColumn in the tableView, as usual.
 */
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
}

#pragma mark -
#pragma mark ***** Common Delegate Methods *****

/* Optional - called whenever the user is about to change the selection. Return NO to prevent the selection from being changed at that time.
 */
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView {
    return NO;
}

/* Optional - Return YES if 'row' should be selected and NO if it should not. For better performance and better control over the selection, you should use tableView:selectionIndexesForProposedSelection:.
 */
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
}

/* Optional - Return a set of new indexes to select when the user changes the selection with the keyboard or mouse. If implemented, this method will be called instead of tableView:shouldSelectRow:. This method may be called multiple times with one new index added to the existing selection to find out if a particular index can be selected when the user is extending the selection with the keyboard or mouse. Note that 'proposedSelectionIndexes' will contain the entire newly suggested selection, and you can return the exsiting selection to avoid changing the selection.
 */
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    return nil;
}

/* Optional - Variable Row Heights
   Implement this method to support a table with varying row heights. The height returned by this method should not include intercell spacing and must be greater than zero. Performance Considerations: For large tables in particular, you should make sure that this method is efficient. NSTableView may cache the values this method returns, but this should NOT be depended on, as all values may not be cached. To signal a row height change, call -noteHeightOfRowsWithIndexesChanged:. For a given row, the same row height should always be returned until -noteHeightOfRowsWithIndexesChanged: is called, otherwise unpredicable results will happen. NSTableView automatically invalidates its entire row height cache in -reloadData, and -noteNumberOfRowsChanged.
 */
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 0;
}

@end
