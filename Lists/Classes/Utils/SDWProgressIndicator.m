//
//  SDWProgressIndicator.m
//  Lists
//
//  Created by alex on 11/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SDWProgressIndicator.h"


@interface SDWProgressIndicator ()

@property (strong) CAShapeLayer *lineLayer;
@property (strong) CAShapeLayer *line1Layer;
@property (strong) CAShapeLayer *line2Layer;

@end

@implementation SDWProgressIndicator

- (void)animateOnce {

    self.line2Layer = [[CAShapeLayer alloc]init];
    self.line2Layer.position = CGPointMake(15, 40);
    self.line2Layer.fillColor = [NSColor whiteColor].CGColor;
    self.line2Layer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 60, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.line2Layer];

    self.lineLayer = [[CAShapeLayer alloc]init];
    self.lineLayer.position = CGPointMake(15, 20);
    self.lineLayer.fillColor = [NSColor whiteColor].CGColor;
    self.lineLayer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 45, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.lineLayer];


    self.line1Layer = [[CAShapeLayer alloc]init];
    self.line1Layer.position = CGPointMake(15, 0);
    self.line1Layer.fillColor = [NSColor whiteColor].CGColor;
    self.line1Layer.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 30, 15), 2, 2, &CGAffineTransformIdentity);

    [self.layer addSublayer:self.line1Layer];


    self.lineLayer.opacity = self.line1Layer.opacity =  self.line2Layer.opacity = 0;

    [self performSelector:@selector(animateGroup1) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(animateGroup2) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(animateGroup3) withObject:nil afterDelay:0.4];

}

- (void)animateGroup1 {

    CABasicAnimation * animation2;
    animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = [NSNumber numberWithInt:0.0];
    animation2.toValue = [NSNumber numberWithInt:1];
    animation2.duration = 0.4;
    animation2.autoreverses = YES;
    animation2.repeatDuration = HUGE_VAL;
    [self.line2Layer addAnimation:animation2 forKey:@"primary_on2"];

}

- (void)animateGroup2 {

    CABasicAnimation * animation;
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithInt:0.0];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 0.4;
    animation.autoreverses = YES;
    animation.repeatDuration = HUGE_VAL;
    [self.lineLayer addAnimation:animation forKey:@"primary_on"];


}


- (void)animateGroup3 {


    CABasicAnimation * animation1;
    animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue = [NSNumber numberWithInt:0.0];
    animation1.toValue = [NSNumber numberWithInt:1];
    animation1.duration = 0.4;
    animation1.autoreverses = YES;
    animation1.repeatDuration = HUGE_VAL;
    [self.line1Layer addAnimation:animation1 forKey:@"primary_on1"];
}


@end
