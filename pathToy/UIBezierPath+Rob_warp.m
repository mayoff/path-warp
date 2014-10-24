//
//  UIBezierPath+Rob_warp.m
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import "UIBezierPath+Rob_warp.h"
#import "UIBezierPath+Rob_forEach.h"
#import <tgmath.h>

static CGPoint minus(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static CGFloat length(CGPoint vector) {
    return hypot(vector.x, vector.y);
}

static CGFloat dotProduct(CGPoint a, CGPoint b) {
    return a.x * b.x + a.y * b.y;
}

static CGFloat crossProductMagnitude(CGPoint a, CGPoint b) {
    return a.x * b.y - a.y * b.x;
}

@implementation UIBezierPath (Rob_warp)

- (UIBezierPath *)Rob_warpedWithFixedPoint:(CGPoint)fixedPoint startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {

    CGPoint startVector = minus(startPoint, fixedPoint);
    CGFloat startLength = length(startVector);
    CGPoint endVector = minus(endPoint, fixedPoint);
    CGFloat endLength = length(minus(endPoint, fixedPoint));
    CGFloat scale = endLength / startLength;

    CGFloat dx = dotProduct(startVector, endVector);
    CGFloat dy = crossProductMagnitude(startVector, endVector);
    CGFloat radians = atan2(dy, dx);

//    CGAffineTransform warpTransform = CGAffineTransformMake(cosine, sine, -sine, cosine, 0, 0);

    CGPoint (^warp)(CGPoint) = ^(CGPoint input){
        CGAffineTransform t = CGAffineTransformMakeTranslation(-fixedPoint.x, -fixedPoint.y);
        CGPoint inputVector = minus(input, fixedPoint);
        CGFloat factor = dotProduct(inputVector, startVector) / (startLength * startLength);
        CGAffineTransform w = CGAffineTransformMakeRotation(radians * factor);
        t = CGAffineTransformConcat(t, w);
        CGFloat factoredScale = pow(scale, factor);
        t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(factoredScale, factoredScale));
        // Note: next line is not the same as CGAffineTransformTranslate!
        t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(fixedPoint.x, fixedPoint.y));
        return CGPointApplyAffineTransform(input, t);
    };

    UIBezierPath *copy = [self.class bezierPath];
    [self Rob_forEachMove:^(CGPoint destination) {
        [copy moveToPoint:warp(destination)];
    } line:^(CGPoint destination) {
        [copy addLineToPoint:warp(destination)];
    } quad:^(CGPoint control, CGPoint destination) {
        [copy addQuadCurveToPoint:warp(destination) controlPoint:warp(control)];
    } cubic:^(CGPoint control0, CGPoint control1, CGPoint destination) {
        [copy addCurveToPoint:warp(destination) controlPoint1:warp(control0) controlPoint2:warp(control1)];
    } close:^{
        [copy closePath];
    }];
    return copy;
}

@end
