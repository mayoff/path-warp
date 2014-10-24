//
//  UIBezierPath+Rob_warp.h
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Rob_warp)

- (UIBezierPath *)Rob_warpedWithFixedPoint:(CGPoint)fixedPoint startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
