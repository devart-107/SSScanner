//
//  BoundingView.m
//  SSBAR
//
//  Created by devart107 on 9/21/14.
//  Copyright (c) 2014 devart107. All rights reserved.
//

#import "BoundingView.h"

@interface BoundingView ()

@property (nonatomic, strong) CAShapeLayer *outline;

@end

@implementation BoundingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _outline = [CAShapeLayer new];
        _outline.strokeColor = [[[UIColor redColor] colorWithAlphaComponent:0.8] CGColor];
        _outline.lineWidth = 2.5;
        _outline.fillColor = [[UIColor clearColor] CGColor];
        [self.layer addSublayer:_outline];
    }
    return self;
}

- (void)setCorners:(NSArray *)corners
{
    if (corners != _corners)
    {
        _corners = corners;
        _outline.path = [[self createLineWithPoints:corners] CGPath];
    }
}

- (UIBezierPath *) createLineWithPoints:(NSArray *)points
{
    // Create a new bezier path
    UIBezierPath *path = [UIBezierPath new];
    
    // AVFoundation provides points in an array, ordered counterclockwise
    [path moveToPoint:[[points firstObject] CGPointValue]];
    
    // Draw lines around the corners
    for (NSUInteger i = 1; i < [points count]; i++)
    {
        [path addLineToPoint:[points[i] CGPointValue]];
    }
    
    // Close up the line to the first corner - complete the path
    [path addLineToPoint:[[points firstObject] CGPointValue]];
    
    return path;
}


@end
