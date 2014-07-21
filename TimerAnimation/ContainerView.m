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
#import "Constants.h"

@interface ContainerView ()
@property (nonatomic, strong) ScaleView *scale;
@property (nonatomic, strong) ScrollTimerView *scroll;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) BOOL useVelocity;

@end

@implementation ContainerView


- (id)initWithFrame:(CGRect)frame usingVelocity:(BOOL)isVelo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.useVelocity = isVelo;
        
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
    
    //int tempMin = hours * 60 + min;
   
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
    self.scale.trianglePoint = CGPointMake((self.bounds.size.width - 2*CORNER_OFFSET) * (_minutes / (float)MAX_MINUTES) + CORNER_OFFSET, CORNER_OFFSET);
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
    self.scroll.timerLabel.frame = CGRectMake(0, self.scroll.timerLabel.bounds.origin.y - dist * 0.90, self.bounds.size.width, self.bounds.size.height);

    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.touchLocation = [touch locationInView:self];
    
    if (!self.useVelocity){
        self.minutes = ([touch locationInView:self].x - CORNER_OFFSET) / (self.bounds.size.width - 2*CORNER_OFFSET) * MAX_MINUTES;
    }
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
    //self.scale.trianglePoint = [touch locationInView:self];
    
    if (self.useVelocity){
        float dx = [touch locationInView:self].x - self.touchLocation.x;//difference in pts between last touch and current touch
        
        float velo = (fabsf(dx) / 2) * dx;//formula to account for velocity of the swipe **subject to change**
        
        //checks for lower and upper bounds for velo
        dx = (velo > -MIN_MINUTE_DX && velo < MIN_MINUTE_DX) ? (velo > 0) ? MIN_MINUTE_DX : -MIN_MINUTE_DX : velo;//if velo is between -1 and 1, set it to -1 or 1, depending on sign
        dx = (dx > MAX_MINUTE_DX) ? MAX_MINUTE_DX : dx;
        dx = (dx < -MAX_MINUTE_DX) ? -MAX_MINUTE_DX : dx;
        
        self.minutes += dx;
        //NSLog(@"Dx: %f", dx);
        self.touchLocation = [touch locationInView:self];
    } else if (!self.useVelocity){
        self.minutes = ([touch locationInView:self].x - CORNER_OFFSET) / (self.bounds.size.width - 2*CORNER_OFFSET) * MAX_MINUTES;
    }
    
}

+(UIColor*)colorWithHexString:(NSString*)hex //found online at http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}
@end
