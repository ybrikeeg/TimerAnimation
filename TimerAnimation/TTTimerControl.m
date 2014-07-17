//
//  TTTimerControl.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/17/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerControl.h"

@interface TTTimerControl ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic) CGPoint touchLocation;

@end

@implementation TTTimerControl

#define MAX_MINUTES 1440
#define MIN_MINUTES 0
#define LABEL_ANIMATE_DISTANCE 70
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [TTTimerControl colorWithHexString:@"556270"];

        self.minutes = 0;
        self.touchLocation = CGPointZero;

        self.timeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.timeLabel.text = @"0:00";
        self.timeLabel.font = [UIFont fontWithName:@"Verdana" size:32.0f];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        
        
    }
    return self;
}

- (NSString *)convertMinutesToHoursInStringFormat:(int)minutes
{
    int hours = minutes / 60;
    int min = ((minutes % 60) / 15) * 15;
    
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
    self.timeLabel.text = [self convertMinutesToHoursInStringFormat:minutes];
}

- (void)animateLabelWithDistance:(int)dist
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.timeLabel.center = CGPointMake(self.timeLabel.center.x, self.timeLabel.center.y + dist);
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchLocation.x != 0 || self.touchLocation.y != 0){
        NSLog(@"What");
    }
    UITouch *touch = [[event allTouches] anyObject];
    self.touchLocation = [touch locationInView:self];
    [self animateLabelWithDistance: -LABEL_ANIMATE_DISTANCE];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchLocation = CGPointZero;
    [self animateLabelWithDistance: LABEL_ANIMATE_DISTANCE];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchLocation = CGPointZero;
    [self animateLabelWithDistance: LABEL_ANIMATE_DISTANCE];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    float dx = [touch locationInView:self].x - self.touchLocation.x;//difference in pts between last touch and current touch

    float velo = (fabsf(dx) / 2) * dx;//formula to account for velocity of the swipe **subject to change**
    
    dx = (velo > -1 && velo < 1) ? (velo > 0) ? 1 : -1 : velo;//if velo is between -1 and 1, set it to -1 or 1, depending on sign
    self.minutes += dx;
    
    NSLog(@"Diference: %f", dx);
    
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
