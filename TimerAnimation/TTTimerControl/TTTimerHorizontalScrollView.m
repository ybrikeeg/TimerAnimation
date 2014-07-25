//
//  ScrollTimerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerHorizontalScrollView.h"
#import "TTTimerScaleView.h"
#import "TTTimerControl.h"
#import "Constants.h"

@interface TTTimerHorizontalScrollView ()
@end
@implementation TTTimerHorizontalScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.timerLabel.text = @"0 hrs 0 mins";
        self.timerLabel.font = [UIFont systemFontOfSize:36.0f];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

        [self addSubview:self.timerLabel];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    //draws the bottom part of the rounded rect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, STROKE_WIDTH);
    
    CGRect rrect = self.bounds;
    CGFloat radius = CORNER_RADIUS;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect);
    miny = CORNER_RADIUS;
    
    CGContextMoveToPoint(context, STROKE_WIDTH/2, miny);
    CGContextAddArcToPoint(context, minx + STROKE_WIDTH/2, maxy - STROKE_WIDTH/2, midx, maxy, radius);
    CGContextAddArcToPoint(context, maxx - STROKE_WIDTH/2, maxy - STROKE_WIDTH/2, maxx, midy, radius);
    CGContextAddLineToPoint(context, maxx - STROKE_WIDTH/2, miny);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //draw the top of the rounded rect so you cannot see the scale when its under the scroll view
    rrect = CGRectInset(CGRectMake(0, 0, self.bounds.size.width, CORNER_RADIUS * 2), STROKE_WIDTH + 1, STROKE_WIDTH + 1);
    minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    miny = CGRectGetMinY(rrect),
    midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect);

    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddLineToPoint(context,maxx, maxy);
    CGContextAddLineToPoint(context,minx, maxy);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
}
@end
