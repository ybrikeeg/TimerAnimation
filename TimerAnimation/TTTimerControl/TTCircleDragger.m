//
//  TTCircleDragger.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 8/1/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTCircleDragger.h"

@implementation TTCircleDragger

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draws filled rectangle
    CGContextSetRGBFillColor(context, 89.0f/255.0f, 223.0f/255.0f, 255.0f/255.0f, 1.0f);
    
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextFillPath(context);
}


@end
