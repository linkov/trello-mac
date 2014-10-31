//
//  LeftMenuOutlineCellView.m
//  Trellobyte
//
//  Created by alex on 10/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "LeftMenuOutlineCellView.h"
#import "Xtrace.h"

@implementation LeftMenuOutlineCellView

//- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//
//    return [NSColor greenColor];
//}
//
//

//- (void)_getTextColor:(NSColor *)color backgroundColor:(NSColor *)backgroundColor {
//
//}

- (void)awakeFromNib {

//    [Xtrace describeValues:YES];
//    [Xtrace showArguments:YES];
//    [Xtrace showCaller:YES];
//    [Xtrace includeMethods:@"setTextColor"];
//    [Xtrace includeMethods:@"getTextColor"];
//    [self xtrace];


//    NSString *titleValue = @"TEST";
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:titleValue];
//    NSColor *color = [self isHighlighted] ? [NSColor whiteColor] : [NSColor blackColor];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [NSFont boldSystemFontOfSize:[NSFont systemFontSize] + 1], NSFontAttributeName,
//                                 color, NSForegroundColorAttributeName, nil];
//    [titleString addAttributes:attributes range:[titleValue rangeOfString:titleValue]];
//    [self setAttributedStringValue:titleString];

}

- (void)updateCellDisplay {
//    if (self.selected || self.highlighted) {
//        self.nameLabel.textColor = [NSColor lightGrayColor];
//        self.colorLabel.textColor = [NSColor lightGrayColor];
//    }
//    else {
        self.textColor = [NSColor whiteColor];
      //  self.textColor = [NSColor blackColor];
//    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    [self updateCellDisplay];
//}
//
//- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    [self updateCellDisplay];
//}

//- (BOOL)_shouldUseStyledTextInView:(NSView *)view {
//    return NO;
//}

//- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
//
//    if (self.backgroundStyle == NSBackgroundStyleLight) {
//        self.textColor = [NSColor greenColor];
//    } else {
//        self.textColor = [NSColor blueColor];
//    }
//
//}
////
//- (void)setTextColor:(NSColor *)textColor {
//
//    _textColor = [NSColor yellowColor];
//
//}
//


//- (NSDictionary *)_textAttributes {
//
//
//    NSDictionary* attributes = [NSMutableDictionary dictionary];
//    [attributes setValue:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]] forKey:NSFontAttributeName];
//    [attributes setValue:[NSColor greenColor] forKey:NSForegroundColorAttributeName];
//    [attributes setValue:[NSColor whiteColor] forKey:NSBackgroundColorAttributeName];
//    return attributes;
//}

//- (void)_getTextColor:(NSColor *)color backgroundColor:(NSColor *)backgroundColor {
//    NSLog(@"check");
//  //  return [NSColor blueColor];
//}

//
//- (void)setHighlighted:(BOOL)highlighted {
//
//    NSLog(@"setHighlighted - %@",highlighted ? @"YES" : @"NO");
//}


@end
