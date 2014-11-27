//
//  SDWProgressIndicator.m
//  Lists
//
//  Created by alex on 11/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWAppSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWProgressIndicator.h"


@interface SDWProgressIndicator ()

@property (strong) CAShapeLayer *lineLayer;
@property (strong) CAShapeLayer *line1Layer;
@property (strong) CAShapeLayer *line2Layer;

@end

@implementation SDWProgressIndicator


- (void)animate {

    CGColorRef lineColor =[NSColor colorWithHexColorString:@"1E5676"].CGColor;

    self.line2Layer = [[CAShapeLayer alloc]init];
    self.line2Layer.position = CGPointMake(15, 40);
    self.line2Layer.fillColor = lineColor;
    self.line2Layer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 60, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.line2Layer];

    self.lineLayer = [[CAShapeLayer alloc]init];
    self.lineLayer.position = CGPointMake(15, 20);
    self.lineLayer.fillColor = lineColor;
    self.lineLayer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 45, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.lineLayer];


    self.line1Layer = [[CAShapeLayer alloc]init];
    self.line1Layer.position = CGPointMake(15, 0);
    self.line1Layer.fillColor = lineColor;
    self.line1Layer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 30, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.line1Layer];

    self.lineLayer.opacity = self.line1Layer.opacity =  self.line2Layer.opacity = 0;

    [self.line2Layer addAnimation:[self opacityAnimationWithBeginTime:0.1] forKey:@"op1"];
    [self.lineLayer addAnimation:[self opacityAnimationWithBeginTime:0.3] forKey:@"op2"];
    [self.line1Layer addAnimation:[self opacityAnimationWithBeginTime:0.5] forKey:@"op3"];


}

- (void)stopAnimation {

   // self.hidden = YES;
    [self.lineLayer removeAllAnimations];
    [self.line1Layer removeAllAnimations];
    [self.line2Layer removeAllAnimations];
}
- (void)startAnimation {

   // self.hidden = NO;
    [self animate];
}


#pragma mark - Utils
- (CABasicAnimation *)opacityAnimationWithBeginTime:(CFTimeInterval)time {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithInt:0.0];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 0.4;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VAL;
    animation.beginTime = CACurrentMediaTime() + animation.duration*time;

    return animation;
}


@end
