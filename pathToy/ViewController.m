//
//  ViewController.m
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Donated to the public domain.
//

#import "ViewController.h"
#import "UIBezierPath+Rob_warp.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *pathSwitch;

@end

@implementation ViewController {
    NSArray *paths;
    NSArray *pathLayers;
    CAShapeLayer *endAnchorLayer;
    CGPoint endAnchor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pathLayers = @[ [self newFilledPathLayer], [self newStrokedPathLayer] ];
    for (CAShapeLayer *layer in pathLayers) {
        [self.view.layer addSublayer:layer];
    }
    [self initializeEndAnchorLayer];
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
    [self initializeEndAnchor];
    [self updatePath];
}

- (NSUInteger)indexOfVisiblePath {
    return self.pathSwitch.isOn ? 1 : 0;
}

- (UIBezierPath *)visiblePath {
    return paths[self.indexOfVisiblePath];
}

- (IBAction)pathSwitchValueChanged:(id)sender {
    [self setPathLayerVisibilities];
    [self updatePath];
}

- (void)setPathLayerVisibilities {
    NSUInteger visibleIndex = self.indexOfVisiblePath;
    [pathLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:idx != visibleIndex];
    }];
}

- (void)updatePath {
    NSUInteger i = self.indexOfVisiblePath;
    CAShapeLayer *layer = pathLayers[i];
    UIBezierPath *path = paths[i];
    CGRect rect = path.bounds;
    CGPoint fixedPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint startPoint = CGPointMake(fixedPoint.x, CGRectGetMaxY(rect));
    path = [path Rob_warpedWithFixedPoint:fixedPoint startPoint:startPoint endPoint:endAnchor];
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
    static int kBubbleMaxIndex = 7;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i <= kBubbleMaxIndex; ++i) {
        CGFloat t = (CGFloat)i / kBubbleMaxIndex;
        CGFloat radius = 10 * (1 - t) + 2.5 * t;
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

- (void)initializeEndAnchorLayer {
    CGRect rect = CGRectMake(-22, -22, 44, 44);
    endAnchorLayer = [CAShapeLayer layer];
    endAnchorLayer.actions = @{
        @"position": [NSNull null]
    };
    endAnchorLayer.opacity = 0.2;
    endAnchorLayer.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    endAnchorLayer.strokeColor = [UIColor colorWithRed:93.0f/255.0f green:165.0f/255.0f blue:171.0f/255.0f alpha:1.0].CGColor;
    endAnchorLayer.lineWidth = 1.5;
    endAnchorLayer.lineJoin = kCALineJoinRound;
    endAnchorLayer.fillColor = [UIColor colorWithRed:218.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0].CGColor;
    [self.view.layer addSublayer:endAnchorLayer];
}

- (void)initializeEndAnchor {
    CGRect rect = [self.visiblePath bounds];
    [self setEndAnchor:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
}

- (void)setEndAnchor:(CGPoint)point {
    endAnchor = point;
    endAnchorLayer.position = endAnchor;
    [self updatePath];
}

- (IBAction)panRecognizerDidFire:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self.view];
    [sender setTranslation:CGPointZero inView:self.view];
    [self setEndAnchor:CGPointMake(endAnchor.x + offset.x, endAnchor.y + offset.y)];
}

@end
