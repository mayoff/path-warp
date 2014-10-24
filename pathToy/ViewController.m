//
//  ViewController.m
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import "ViewController.h"
#import "PathView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet PathView *pathView;
@property (strong, nonatomic) IBOutlet UISwitch *pathSwitch;

@end

@implementation ViewController {
    NSArray *paths;
    NSArray *pathLayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pathLayers = @[ [self newFilledPathLayer], [self newStrokedPathLayer] ];
    for (CAShapeLayer *layer in pathLayers) {
        [self.view.layer addSublayer:layer];
    }
}

- (CAShapeLayer *)newFilledPathLayer {
    CAShapeLayer *layer = [self newStrokedPathLayer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    return layer;
}

- (CAShapeLayer *)newStrokedPathLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = nil;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.lineWidth = 2;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    return layer;
}

- (void)viewDidLayoutSubviews {
    [self initializePaths];
    [self updatePath];
}

- (NSUInteger)indexOfVisiblePathLayer {
    return self.pathSwitch.isOn ? 1 : 0;
}

- (IBAction)pathSwitchValueChanged:(id)sender {
    [self setPathLayerVisibilities];
    [self updatePath];
}

- (void)setPathLayerVisibilities {
    NSUInteger visibleIndex = self.indexOfVisiblePathLayer;
    [pathLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:idx != visibleIndex];
    }];
}

- (void)updatePath {
    NSUInteger i = self.indexOfVisiblePathLayer;
    CAShapeLayer *layer = pathLayers[i];
    UIBezierPath *path = paths[i];
    layer.path = path.CGPath;
}

- (void)initializePaths {
    CGSize size = self.view.bounds.size;
    size.height = 2 * size.height / 3;
    paths = @[ [self path0WithSize:size], [self path1WithSize:size] ];
    for (UIBezierPath *path in paths) {
        [path applyTransform:CGAffineTransformMakeTranslation(0, 50)];
    }
}

- (UIBezierPath *)path0WithSize:(CGSize)size {
    CGFloat x = size.width / 2;
    static int kBubbleMaxIndex = 10;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i <= kBubbleMaxIndex; ++i) {
        CGFloat t = (CGFloat)i / kBubbleMaxIndex;
        CGFloat radius = 15 * (1 - t) + 2.5 * t;
        CGRect bubbleRect = CGRectMake(x - radius, t * size.height - radius, 2 * radius, 2 * radius);
        UIBezierPath *bubble = [UIBezierPath bezierPathWithOvalInRect:bubbleRect];
        [path appendPath:bubble];
    }
    path.lineWidth = 2;
    path.lineJoinStyle = kCGLineJoinRound;
    return path;
}

- (UIBezierPath *)path1WithSize:(CGSize)size {
    CGFloat xMid = size.width / 2;
    CGFloat yMid = size.height / 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xMid - 40, 0)];
    [path addQuadCurveToPoint:CGPointMake(xMid, size.height) controlPoint:CGPointMake(xMid - 10, yMid)];
    [path addQuadCurveToPoint:CGPointMake(xMid + 40, 0) controlPoint:CGPointMake(xMid + 10, yMid)];
    path.lineWidth = 2;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    return path;
}

@end
