//
//  ScaleView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "ScaleView.h"
#import "ContainerView.h"
#import "Constants.h"

@interface ScaleView ()
@end

@implementation ScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [ContainerView colorWithHexString:@"4DAAAB"];
        
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
    //draws the scale
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, CORNER_OFFSET, START_OFFSET);
    CGContextAddArc(context, CORNER_OFFSET + CORNER_RADIUS, CORNER_OFFSET + CORNER_RADIUS, CORNER_RADIUS, M_PI, -M_PI/2, 0);
    CGContextAddLineToPoint(context, CORNER_OFFSET + CORNER_RADIUS, CORNER_OFFSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - CORNER_OFFSET - CORNER_RADIUS, CORNER_OFFSET);
    CGContextAddArc(context, self.bounds.size.width - CORNER_OFFSET - CORNER_RADIUS, CORNER_OFFSET + CORNER_RADIUS, CORNER_RADIUS, -M_PI/2, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width - CORNER_OFFSET, START_OFFSET);

    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [ContainerView colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    //draws the tick marks
    
    for (int i = 1; i < 4; i++){
        CGContextMoveToPoint(context, CORNER_OFFSET + i * (self.bounds.size.width - 2*CORNER_OFFSET) / 4, CORNER_OFFSET);
        CGContextAddLineToPoint(context, CORNER_OFFSET + i * (self.bounds.size.width - 2*CORNER_OFFSET) / 4, CORNER_OFFSET + 5);
        CGContextStrokePath(context);
    }
    
    //draws the triangle
    CGContextMoveToPoint(context, self.trianglePoint.x, self.trianglePoint.y);
    CGContextAddLineToPoint(context, self.trianglePoint.x + .5 * TRIANGLE_SIDE_LENGTH, self.trianglePoint.y + TRIANGLE_OPPOSITE_SIDE);
    CGContextAddLineToPoint(context, self.trianglePoint.x - (.5 * TRIANGLE_SIDE_LENGTH), self.trianglePoint.y + TRIANGLE_OPPOSITE_SIDE);
    CGContextClosePath(context);

    CGContextSetFillColorWithColor(context, [ContainerView colorWithHexString:@"CDDEC6"].CGColor);
    CGContextFillPath(context);
}


@end
