//
//  SDWProgressIndicator.m
//  Lists
//
//  Created by alex on 11/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWProgressIndicator.h"

typedef enum {
    SDWIndicatorTypeRegular = 0,
    SDWIndicatorTypeSmall,
} SDWIndicatorType;

@interface SDWProgressIndicator ()

@property (strong) CAShapeLayer *secondLine;
@property (strong) CAShapeLayer *thirdLine;
@property (strong) CAShapeLayer *firstLine;

@end

@implementation SDWProgressIndicator

- (void)stopAnimation {
    [self.secondLine removeAllAnimations];
    [self.thirdLine removeAllAnimations];
    [self.firstLine removeAllAnimations];

    self.hidden = YES;
}

- (void)awakeFromNib {
    [self _setupLayers];
}

- (void)startAnimation {
    self.hidden = NO;

    if (self.bounds.size.width == 100) {
        [self _setupPositionAndSizeForIndicatorType:SDWIndicatorTypeRegular];
    } else {
        [self _setupPositionAndSizeForIndicatorType:SDWIndicatorTypeSmall];
    }

    [self _runAnimation];
}

- (void)_setupLayers {
    self.wantsLayer = YES;

    CGColorRef lineColor = [SharedSettings appBackgroundColor].CGColor;

    self.firstLine = [[CAShapeLayer alloc]init];
    [self.layer addSublayer:self.firstLine];

    self.secondLine = [[CAShapeLayer alloc]init];
    [self.layer addSublayer:self.secondLine];

    self.thirdLine = [[CAShapeLayer alloc]init];
    [self.layer addSublayer:self.thirdLine];

    self.firstLine.fillColor = self.thirdLine.fillColor = self.secondLine.fillColor = lineColor;
}

- (void)_setupPositionAndSizeForIndicatorType:(SDWIndicatorType)type {
    if (type == SDWIndicatorTypeSmall) {
        self.firstLine.position = CGPointMake(1, 10);
        self.firstLine.path = CGPathCreateWithRoundedRect(NSMakeRect(0, 2, 14, 3), .5, .5, &CGAffineTransformIdentity);

        self.secondLine.position = CGPointMake(1, 5);
        self.secondLine.path = CGPathCreateWithRoundedRect(NSMakeRect(0, 2, 10, 3), .5, .5, &CGAffineTransformIdentity);

        self.thirdLine.position = CGPointMake(1, 0);
        self.thirdLine.path = CGPathCreateWithRoundedRect(NSMakeRect(0, 2, 6, 3), .5, .5, &CGAffineTransformIdentity);
    } else {
        self.firstLine.position = CGPointMake(15, 40);
        self.firstLine.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 60, 15), 2, 2, &CGAffineTransformIdentity);

        self.secondLine.position = CGPointMake(15, 20);
        self.secondLine.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 45, 15), 2, 2, &CGAffineTransformIdentity);

        self.thirdLine.position = CGPointMake(15, 0);
        self.thirdLine.path = CGPathCreateWithRoundedRect(NSMakeRect(4, 20, 30, 15), 2, 2, &CGAffineTransformIdentity);
    }
}

- (void)_runAnimation {
    self.secondLine.opacity = self.thirdLine.opacity = self.firstLine.opacity = 0;

    [self.firstLine addAnimation:[self opacityAnimationWithBeginTime:0.1] forKey:@"op1"];
    [self.secondLine addAnimation:[self opacityAnimationWithBeginTime:0.3] forKey:@"op2"];
    [self.thirdLine addAnimation:[self opacityAnimationWithBeginTime:0.5] forKey:@"op3"];
}

#pragma mark - Utils

- (CABasicAnimation *)opacityAnimationWithBeginTime:(CFTimeInterval)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithInt:0.0];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 0.4;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VAL;
    // animation.removedOnCompletion = YES;
    animation.beginTime = CACurrentMediaTime() + animation.duration * time;

    return animation;
}

@end
