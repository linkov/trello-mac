//
//  SDWCardListView.m
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "PulseView.h"
#import "SDWAppSettings.h"
#import "SDWCardListView.h"
#import "NSColor+Util.h"


@implementation SDWCardListView

#pragma mark - Properties

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

    if(self.hasDescription) {

        NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(3.5, self.bounds.size.height/2-4/2, 4, 4)];

        [[SharedSettings appBackgroundColorDark] setFill];
        [[SharedSettings appBackgroundColorDark] setStroke];
        [ovalPath fill];
       // [ovalPath stroke];
    }

}

- (void)setSelected:(BOOL)selected {

    if (selected) {

        self.fillColor = [SharedSettings appSelectionColor];
    }
    else {

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

- (void)setHasDescription:(BOOL)hasDescription {
    _hasDescription = hasDescription;

    [self setNeedsDisplay:YES];
}

- (void)awakeFromNib {

  [self setTranslatesAutoresizingMaskIntoConstraints:NO];

}

-(IBAction)setCRRR:(id)sender {}
- (void)expand {}

@end
