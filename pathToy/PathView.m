//
//  PathView.m
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import "PathView.h"

@implementation PathView

- (void)setPath:(UIBezierPath *)path {
    _path = [path copy];
    [self setNeedsDisplay];
}

- (void)setAnchor:(CGPoint)anchor {
    _anchor = anchor;
    [self setNeedsDisplay];
}

- (void)setStart:(CGPoint)start {
    _start = start;
    [self setNeedsDisplay];
}

- (void)setEnd:(CGPoint)end {
    _end = end;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.path stroke];
    [self.path fill];
}

@end
