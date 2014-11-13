//
//  WSCBoardsOutlineView.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "WSCBoardsOutlineView.h"

@interface WSCBoardsOutlineView ()

@property NSUInteger contextRow;

@end

@implementation WSCBoardsOutlineView

- (void)awakeFromNib {
    self.intercellSpacing = CGSizeMake(0, 5);
}

//-(NSMenu*)menuForEvent:(NSEvent*)evt
//{
//    NSPoint pt = [self convertPoint:[evt locationInWindow] fromView:nil];
//    NSUInteger row = [self rowAtPoint:pt];
//    return [self defaultMenuForRow:row];
//}
//
//-(NSMenu*)defaultMenuForRow:(NSUInteger)row {
//
//    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Model browser context menu"];
//
//    [theMenu insertItemWithTitle:@"Add package"
//                          action:@selector(addSite:)
//                   keyEquivalent:@""
//                         atIndex:0];
//    [theMenu insertItemWithTitle:[NSString stringWithFormat:@"Remove '%lu'", (unsigned long)row]
//                          action:@selector(removeSite:)
//                   keyEquivalent:@""
//                         atIndex:0];
//    // you'll need to find a way of getting the information about the
//    // row that is to be removed to the removeSite method
//    // assuming that an ivar 'contextRow' is used for this
//    self.contextRow = row;
//
//    return theMenu;
//}
//
//- (void)addSite:(id)sender {
//
//}
//
//- (void)removeSite:(id)sender {
//
//}

@end
