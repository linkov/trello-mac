//
//  SDWBoardsListRow.m
//  Lists
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "SDWBoardsListRow.h"

@implementation SDWBoardsListRow

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
//    [[SharedSettings appBackgroundColorDark] set];
//    [NSBezierPath fillRect:drawRect];
//}

- (void)drawDraggingDestinationFeedbackInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightGreenColor] set];
    [NSBezierPath fillRect:drawRect];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightColor] set];
    [NSBezierPath fillRect:drawRect];

//    NSBezierPath* bezier2Path = NSBezierPath.bezierPath;
//    [bezier2Path moveToPoint: NSMakePoint(133, 22)];
//    [bezier2Path curveToPoint: NSMakePoint(183.25, 22) controlPoint1: NSMakePoint(133, 22) controlPoint2: NSMakePoint(183.25, 22)];
//    [bezier2Path lineToPoint: NSMakePoint(194, 11.46)];
//    [bezier2Path lineToPoint: NSMakePoint(183.25, 0)];
//    [bezier2Path lineToPoint: NSMakePoint(0, 0)];
//    [bezier2Path lineToPoint: NSMakePoint(0, 22)];
//    [bezier2Path lineToPoint: NSMakePoint(133, 22)];
//    [bezier2Path lineToPoint: NSMakePoint(133, 22)];
//    [bezier2Path closePath];
//    [[NSColor colorWithHexColorString:@"3E6378"] setFill];
//    [bezier2Path fill];
}

@end
