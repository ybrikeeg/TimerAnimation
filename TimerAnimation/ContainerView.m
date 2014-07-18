//
//  ContainerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "ContainerView.h"
#import "ScaleView.h"
#import "ScrollTimerView.h"

@interface ContainerView ()
@property (nonatomic, strong) ScaleView *scale;
@property (nonatomic, strong) ScrollTimerView *scroll;
@end
@implementation ContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scroll = [[ScrollTimerView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.scroll];
        
        self.scale = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.scale];

        
        [self sendSubviewToBack:self.scale];
    
    }
    return self;
}

- (void)moveScaleView:(int)dist
{
    //move scale view up top
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.scale.frame = CGRectMake(0, self.scale.bounds.origin.y - dist, self.bounds.size.width, self.bounds.size.height);
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveScaleView:80];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveScaleView:-80];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveScaleView:-80];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.scale.trianglePoint = [touch locationInView:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
