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
@property (nonatomic) CGPoint touchLocation;

@end

@implementation ContainerView

#define MAX_MINUTES 1440
#define MIN_MINUTES 0
#define MIN_MINUTE_DX 3
#define MAX_MINUTE_DX 150
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

- (NSString *)convertMinutesToHoursInStringFormat:(int)minutes
{
    int hours = minutes / 60;
    int min = ((minutes % 60) / 15) * 15;
    
    //_minutes = hours * 60 + min;
    return [NSString stringWithFormat:@"%d:%02d", hours, min];
}

- (void)setMinutes:(int)minutes
{
    //bounds checking for minutes instance var
    if (minutes < MIN_MINUTES){
        minutes = MIN_MINUTES;
    } else if (minutes > MAX_MINUTES){
        minutes = MAX_MINUTES;
    }
    
    _minutes = minutes;

    self.scroll.timerLabel.text = [self convertMinutesToHoursInStringFormat:minutes];
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
    self.scroll.timerLabel.frame = CGRectMake(0, self.scroll.timerLabel.bounds.origin.y - dist, self.bounds.size.width, self.bounds.size.height);

    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.touchLocation = [touch locationInView:self];
    [self moveScaleView:80];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveScaleView:0];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self moveScaleView:0];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.scale.trianglePoint = [touch locationInView:self];
    
    
    float dx = [touch locationInView:self].x - self.touchLocation.x;//difference in pts between last touch and current touch
    
    float velo = (fabsf(dx) / 2) * dx;//formula to account for velocity of the swipe **subject to change**
    
    //checks for lower and upper bounds for velo
    dx = (velo > -MIN_MINUTE_DX && velo < MIN_MINUTE_DX) ? (velo > 0) ? MIN_MINUTE_DX : -MIN_MINUTE_DX : velo;//if velo is between -1 and 1, set it to -1 or 1, depending on sign
    dx = (dx > MAX_MINUTE_DX) ? MAX_MINUTE_DX : dx;
    dx = (dx < -MAX_MINUTE_DX) ? -MAX_MINUTE_DX : dx;
    
    self.minutes += dx;
    NSLog(@"Dx: %f", dx);
    //NSLog(@"Diference: %f", dx);
    self.touchLocation = [touch locationInView:self];
    
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
