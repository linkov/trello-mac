//
//  SDWCardListView.m
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#define kCardLabelPad 8

#import "PulseView.h"
#import "SDWAppSettings.h"
#import "SDWCardListView.h"
#import "NSColor+Util.h"
#import "SDWLabel.h"
#import "Utils.h"

@implementation SDWCardListView

#pragma mark - Properties

- (void)awakeFromNib {

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.fillColor =  [NSColor whiteColor];
    self.cornerRadius = 1.5;
    self.borderColor = [NSColor clearColor];
    self.borderWidth = 0;
}

- (void)drawRect:(NSRect)dirtyRect {

     [super drawRect:dirtyRect];

    if (self.shouldDrawSideLine || self.shouldDrawSideLineAmber) {

        CGFloat rectangleCornerRadius = 1.5;
        NSRect rectangleRect = NSMakeRect(0, 0, 1.5, self.bounds.size.height);
        NSRect rectangleInnerRect = NSInsetRect(rectangleRect, rectangleCornerRadius, rectangleCornerRadius);
        NSBezierPath* rectanglePath = NSBezierPath.bezierPath;
        [rectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle: 180 endAngle: 270];
        [rectanglePath lineToPoint: NSMakePoint(NSMaxX(rectangleRect), NSMinY(rectangleRect))];
        [rectanglePath lineToPoint: NSMakePoint(NSMaxX(rectangleRect), NSMaxY(rectangleRect))];
        [rectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle: 90 endAngle: 180];
        [rectanglePath closePath];
        
        if (self.shouldDrawSideLineAmber) {
            [[NSColor colorWithHexColorString:@"FAB243"] setFill];
        } else {
            [[NSColor colorWithHexColorString:@"FA2A00"] setFill];

        }

        [rectanglePath fill];
    }

    if(self.hasDot) {

        NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(3.5, self.bounds.size.height/2-4/2, 4, 4)];

        [[SharedSettings appBackgroundColorDark] setFill];
        [[SharedSettings appBackgroundColorDark] setStroke];
        [ovalPath fill];
    }

    for (SDWLabel *label in self.labels) {
//        NSLog(@"label - %@",label.color);

        CGFloat xPos = self.bounds.size.width - self.labels.count*kCardLabelPad + ([self.labels indexOfObject:label]*kCardLabelPad);

        NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(xPos, 4, 3, 3)];
        [[SharedSettings colorForTrelloColor:label.color] setStroke];

        [ovalPath stroke];
    }

}

- (void)setSelected:(BOOL)selected {
	if (selected) {
		self.fillColor = [SharedSettings appSelectionColor];
	} else {

		self.fillColor = [NSColor whiteColor];
	}
}

- (void)setShouldDrawSideLine:(BOOL)shouldDrawSideLine {
	_shouldDrawSideLine = shouldDrawSideLine;
	[self setNeedsDisplay:YES];
}


- (void)setShouldDrawSideLineAmber:(BOOL)shouldDrawSideLineAmber {
    _shouldDrawSideLineAmber = shouldDrawSideLineAmber;
    [self setNeedsDisplay:YES];
}

- (void)setLabels:(NSArray *)labels {
    _labels = labels;
    [self setNeedsDisplay:YES];
}

- (void)setHasDot:(BOOL)hasDot {
    _hasDot = hasDot;

    [self setNeedsDisplay:YES];
}

@end
