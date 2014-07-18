//
//  ScaleView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "ScaleView.h"

@interface ScaleView ()
@end

@implementation ScaleView

#define CORNER_OFFSET 15
#define START_OFFSET 40
#define TRIANGLE_SIDE_LENGTH 10
#define TRIANGLE_OPPOSITE_SIDE sin(60 * M_PI/180) * TRIANGLE_SIDE_LENGTH

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
        self.trianglePoint = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    }
    return self;
}

- (void)setTrianglePoint:(CGPoint)trianglePoint
{
    if (trianglePoint.x < CORNER_OFFSET) return;
    if (trianglePoint.x > self.bounds.size.width - CORNER_OFFSET) return;
    
    _trianglePoint = CGPointMake(trianglePoint.x, CORNER_OFFSET);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, CORNER_OFFSET, START_OFFSET);
    CGContextAddLineToPoint(context, CORNER_OFFSET, CORNER_OFFSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - CORNER_OFFSET, CORNER_OFFSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - CORNER_OFFSET, START_OFFSET);

    CGFloat dashArray[] = {5, 5, 5, 5, 5, 5};
    CGContextSetLineDash(context, 0, dashArray, 0);
    CGContextSetLineWidth(context, 2.0);
    
    //CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, self.trianglePoint.x, self.trianglePoint.y);
    CGContextAddLineToPoint(context, self.trianglePoint.x + .5 * TRIANGLE_SIDE_LENGTH, self.trianglePoint.y + TRIANGLE_OPPOSITE_SIDE);
    CGContextAddLineToPoint(context, self.trianglePoint.x - (.5 * TRIANGLE_SIDE_LENGTH), self.trianglePoint.y + TRIANGLE_OPPOSITE_SIDE);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextFillPath(context);
}


@end
