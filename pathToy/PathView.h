//
//  PathView.h
//  pathToy
//
//  Created by Rob Mayoff on 10/24/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathView : UIView

@property (nonatomic, copy) UIBezierPath *path;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic) CGPoint anchor;
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;

@end
