//
//  PulseView.m
//  Lists
//
//  Created by alex on 11/13/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//


//
//  DOBRPulseView.m
//  test2
//
//  Created by David Oliver Barreto Rodríguez on 27/12/13.
//  Copyright (c) 2013 David Oliver Barreto Rodríguez. All rights reserved.
//
// This is much simpler if you don't draw the circle in drawRect:. Instead, set up your view to use a CAShapeLayer, like this:
#import <Quartz/Quartz.h>
#import "PulseView.h"

@implementation PulseView

#pragma mark Custom Code
- (CALayer *)makeBackingLayer {
    return [CAShapeLayer new];
}


// The system sends layoutSubviews to your view whenever it changes size (including when it first appears). We override layoutSubviews to set up the shape and animate it:

- (void)layout {

    [super layout];
    [self setLayerProperties];
    [self attachAnimations];

}

//- (void)layoutSubviews {
//    [self setLayerProperties];
//    [self attachAnimations];
//}

// Here's how we set the layer's path (which determines its shape) and the fill color for the shape:

- (void)setLayerProperties {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;

    CGPathRef ref =  (__bridge CGPathRef)([NSBezierPath bezierPathWithOvalInRect:self.bounds]);

    layer.path = ref;
    layer.fillColor = [NSColor colorWithHue:0 saturation:1 brightness:.8 alpha:1].CGColor;
}


// We need to attach two animations to the layer - one for the path and one for the fill color:

- (void)attachAnimations {
    [self attachPathAnimation];
    [self attachColorAnimation];
}

// Here's how we animate the layer's path:

- (void)attachPathAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id)((__bridge CGPathRef)[NSBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 4, 4)]);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

// Here's how we animate the layer's fill color:

- (void)attachColorAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)[NSColor colorWithHue:0 saturation:.9 brightness:.9 alpha:1].CGColor;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

// Both of the attach*Animation methods use a helper method that creates a basic animation and sets it up to repeat indefinitely with autoreverse and a one second duration:

- (CABasicAnimation *)animationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1;
    return animation;
}



#pragma mark init code

- (id)initWithFrame:(NSRect)frameRect {

    self = [super initWithFrame:frameRect];
    if (self) {
    }
    return self;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end