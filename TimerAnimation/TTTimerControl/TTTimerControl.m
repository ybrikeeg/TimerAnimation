//
//  ContainerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerControl.h"
#import "TTTimerScaleView.h"
#import "TTTimerHorizontalScrollView.h"
#import "Constants.h"

@interface TTTimerControl ()
@property (nonatomic, strong) TTTimerScaleView *scale;
@property (nonatomic, strong) TTTimerHorizontalScrollView *scroll;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic, strong) NSTimer *mainTimer;
@property (nonatomic) CGPoint firstTouch;
@property (nonatomic) BOOL isEditingStartDate;
@property (nonatomic, strong) UILabel *helper;
@end

@implementation TTTimerControl


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scroll = [[TTTimerHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.scroll];
        
        self.scale = [[TTTimerScaleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.scale];
        
        [self sendSubviewToBack:self.scale];
        
        self.minutes = 0;
        self.isEditingStartDate = NO;
        
        self.helper = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * 0.40f, self.bounds.size.width, self.bounds.size.height)];
        self.helper.text = @"TAP TO EDIT START TIME";
        self.helper.textAlignment = NSTextAlignmentCenter;
        self.helper.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.helper];
    }
    return self;
}

- (void)stopTiming
{
    if (self.startDate){
        int elapsedTime = (int)([self.startDate timeIntervalSinceNow] * -1);
        NSLog(@"elapsed time in mins: %d", elapsedTime/60);
        _minutes = elapsedTime/60;
        self.timerStarted = NO;
        [self.mainTimer invalidate];
        self.scroll.timerLabel.text = @"0 hrs 0 mins";
        self.isEditingStartDate = NO;
        self.helper.hidden = YES;
    }
}

- (NSString *)convertDatetoString
{
    int elapsedTime = (int)([self.startDate timeIntervalSinceNow] * -1);
    int hour = elapsedTime / 3600;
    int min = (elapsedTime % 3600) / 60;
    int sec = elapsedTime % 60;
    return [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];
}

- (void)updateTimer:(NSTimer *)timer
{
    self.scroll.timerLabel.text = [self convertDatetoString];
}

- (void)startTiming
{
    self.timerStarted = YES;
    self.startDate = [NSDate date];
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    //round minutes to nearest multiple of 15
    int hours = self.minutes / 60;
    int min = ((self.minutes % 60) / MINUTE_ROUNDING_TO_NEAREST) * MINUTE_ROUNDING_TO_NEAREST;
    
    int tempMin = hours * 60 + min;
    self.minutes = tempMin;
    self.startDate = [self.startDate dateByAddingTimeInterval:-tempMin * 60];
    self.helper.hidden = YES;
    
    if (self.isEditingStartDate){
        [self moveScaleView:0];
    }
}

- (NSString *)convertMinutesToHoursInStringFormat:(int)minutes
{
    int hours = minutes / 60;
    int min = ((minutes % 60) / MINUTE_ROUNDING_TO_NEAREST) * MINUTE_ROUNDING_TO_NEAREST;
    return [NSString stringWithFormat:@"%d hrs %02d mins", hours, min];
}

- (void)setMinutes:(int)minutes
{
    //bounds checking for minutes instance var
    if (minutes > MAX_MINUTES){
        minutes = MAX_MINUTES;
    }
    if (minutes < MIN_MINUTES){
        minutes = MIN_MINUTES;
    }
    
    _minutes = minutes;
    
    self.scroll.timerLabel.text = [self convertMinutesToHoursInStringFormat:minutes];
    
    [self.scale updateSlidingLabel:minutes];
}

- (void)moveScaleView:(int)dist
{
    //move scale view up top
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.scroll.timerLabel.frame = CGRectMake(0, self.scale.bounds.origin.y - dist * 0.30, self.bounds.size.width, self.bounds.size.height);
    
    self.scale.frame = CGRectMake(0, self.scale.bounds.origin.y - dist, self.bounds.size.width, self.bounds.size.height);
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        UITouch *touch = [[event allTouches] anyObject];
        self.touchLocation = [touch locationInView:self];
        
        if (self.isEditingStartDate){
            
        } else{
            [self moveScaleView:80];
            self.helper.hidden = YES;
        }
        self.isEditingStartDate = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        //[self moveScaleView:0];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        //[self moveScaleView:0];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        UITouch *touch = [[event allTouches] anyObject];
        
        float dx = self.touchLocation.x - [touch locationInView:self].x;//difference in pts between last touch and current touch
        
        self.scale.dx = dx;
        self.minutes +=dx;
        self.touchLocation = [touch locationInView:self];
        
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
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
