//
//  LeftMenuOutlineView.m
//  Trellobyte
//
//  Created by alex on 10/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "LeftMenuOutlineView.h"

@implementation LeftMenuOutlineView

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    
//    // Drawing code here.
//}
//
//
//- (void)awakeFromNib {
//
//    //self.backgroundColor = [NSColor greenColor];
//    [(NSTextFieldCell *)self.selectedCell setBackgroundColor:[NSColor greenColor]];
//}

//- (void)setBackgroundColor:(NSColor *)color {
//
//    [super setBackgroundColor:[NSColor greenColor]];
//}


- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {


    [super drawRow:row clipRect:clipRect];

    NSIndexSet *selectedRowIndexes = [self selectedRowIndexes];
    NSRange visibleRows = [self rowsInRect:clipRect];

    NSUInteger selectedRow = [selectedRowIndexes firstIndex];
    while (selectedRow != NSNotFound)
    {
        if (selectedRow == -1 || !NSLocationInRange(selectedRow, visibleRows))
        {
            selectedRow = [selectedRowIndexes indexGreaterThanIndex:selectedRow];
            continue;
        }

        // determine if this is a group row or not
        id delegate = [self delegate];
        BOOL isGroupRow = NO;
        if ([delegate respondsToSelector:@selector(outlineView:isGroupItem:)])
        {
            id item = [self itemAtRow:selectedRow];
            isGroupRow = [delegate outlineView:self isGroupItem:item];
        }

        if (isGroupRow)
        {
            [[NSColor grayColor] set];
        } else {
            [[NSColor colorWithHexColorString:@"0099CC"] set];
        }

        NSRectFillUsingOperation([self rectOfRow:selectedRow],NSCompositeDestinationAtop);
       // NSRectFill([self rectOfRow:selectedRow]);
        selectedRow = [selectedRowIndexes indexGreaterThanIndex:selectedRow];
    }


}

//- (void)highlightSelectionInClipRect:(NSRect)clipRect
//{
//    NSIndexSet *selectedRowIndexes = [self selectedRowIndexes];
//    NSRange visibleRows = [self rowsInRect:clipRect];
//
//    NSUInteger selectedRow = [selectedRowIndexes firstIndex];
//    while (selectedRow != NSNotFound)
//    {
//        if (selectedRow == -1 || !NSLocationInRange(selectedRow, visibleRows))
//        {
//            selectedRow = [selectedRowIndexes indexGreaterThanIndex:selectedRow];
//            continue;
//        }
//
//        // determine if this is a group row or not
//        id delegate = [self delegate];
//        BOOL isGroupRow = NO;
//        if ([delegate respondsToSelector:@selector(outlineView:isGroupItem:)])
//        {
//            id item = [self itemAtRow:selectedRow];
//            isGroupRow = [delegate outlineView:self isGroupItem:item];
//        }
//
//        if (isGroupRow)
//        {
//            [[NSColor alternateSelectedControlColor] set];
//        } else {
//            [[NSColor secondarySelectedControlColor] set];
//        }
//
//        NSRectFill([self rectOfRow:selectedRow]);
//        selectedRow = [selectedRowIndexes indexGreaterThanIndex:selectedRow];
//    }
//}
@end
