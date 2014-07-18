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
@property (nonatomic) BOOL timerStarted;
@property (nonatomic, strong) NSTimer *mainTimer;

@end

@implementation TTTimerControl

#define MAX_MINUTES 1440
#define MIN_MINUTES 0
#define LABEL_ANIMATE_DISTANCE 65
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [TTTimerControl colorWithHexString:@"556270"];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.timeLabel.text = @"hgfjhgfjhgf00:00:00";
        self.timeLabel.font = [UIFont fontWithName:@"Verdana" size:20.0f];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = [TTTimerControl colorWithHexString:@"4ECEC4"];
        self.timeLabel.backgroundColor = [TTTimerControl colorWithHexString:@"556270"];
        [self.timeLabel sizeToFit];
        self.timeLabel.text = @"0:00";
        
        self.timeLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGRect bounds = self.timeLabel.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(15.0, 15.0)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        self.timeLabel.layer.mask = maskLayer;
        [self addSubview:self.timeLabel];
        
        self.minutes = 0;
        self.touchLocation = CGPointZero;
        self.timerStarted = NO;
        self.mainTimer = nil;
        //_mainTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];

    
    }
    return self;
}

- (NSString *)convertDatetoString
{
    int elapsedTime = (int)([self.startDate timeIntervalSinceNow] * -1);
    int hour = elapsedTime / 3600;
    int min = (elapsedTime % 3600) / 60;
    int sec = elapsedTime % 60;
    NSLog(@"string: %@", [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]);
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
}
- (void)updateTimer:(NSTimer *)timer
{
    NSLog(@"time since: %d", (int)[self.startDate timeIntervalSinceNow] * -1);
    self.timeLabel.text = [self convertDatetoString];

}
- (void)stopTiming
{
    NSLog(@"Stopping timer");
    self.timerStarted = NO;
    [self.mainTimer invalidate];
}

- (void)startTiming
{
    NSLog(@"Starting timer");

    self.timerStarted = YES;
    self.startDate = [NSDate date];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    
    NSString *theDate = [dateFormat stringFromDate:self.startDate];
    NSString *theTime = [timeFormat stringFromDate:self.startDate];
    NSLog(@"thedate: %@", theDate);
    NSLog(@"thetime: %@\n", theTime);
    
    self.startDate = [self.startDate dateByAddingTimeInterval:-self.minutes * 60];
    
    NSString *theDate2 = [dateFormat stringFromDate:self.startDate];
    NSString *theTime2 = [timeFormat stringFromDate:self.startDate];
    NSLog(@"thedate: %@", theDate2);
    NSLog(@"thetime: %@\n\n\n", theTime2);
}
- (NSString *)convertMinutesToHoursInStringFormat:(int)minutes
{
    int hours = minutes / 60;
    int min = ((minutes % 60) / 15) * 15;
    
    _minutes = hours * 60 + min;
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
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.timeLabel.center = CGPointMake(160, self.timeLabel.center.y + dist);
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        if (self.touchLocation.x != 0 || self.touchLocation.y != 0){
            NSLog(@"What");
        }
        UITouch *touch = [[event allTouches] anyObject];
        self.touchLocation = [touch locationInView:self];
        [self animateLabelWithDistance: -LABEL_ANIMATE_DISTANCE];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        
        self.touchLocation = CGPointZero;
        [self animateLabelWithDistance: LABEL_ANIMATE_DISTANCE];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        
        self.touchLocation = CGPointZero;
        [self animateLabelWithDistance: LABEL_ANIMATE_DISTANCE];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        
        UITouch *touch = [[event allTouches] anyObject];
        float dx = [touch locationInView:self].x - self.touchLocation.x;//difference in pts between last touch and current touch
        
        float velo = (fabsf(dx) / 2) * dx;//formula to account for velocity of the swipe **subject to change**
        
        dx = (velo > -1 && velo < 1) ? (velo > 0) ? 1 : -1 : velo;//if velo is between -1 and 1, set it to -1 or 1, depending on sign
        self.minutes += dx;
        
        //NSLog(@"Diference: %f", dx);
        self.touchLocation = [touch locationInView:self];
        
        //NSLog(@"mins: %d", self.minutes);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"F2B134"].CGColor);
 CGContextSetLineWidth(context, 5);
 
 
 CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y);
 NSLog(@"Point: %@", NSStringFromCGPoint(self.bounds.origin));
 
 CGContextAddLineToPoint(context, self.bounds.size.width/2 -  self.timeLabel.bounds.size.width/2, self.bounds.origin.y);
 NSLog(@"Point: %@", NSStringFromCGPoint(CGPointMake(self.bounds.size.width/2 -  self.timeLabel.bounds.size.width/2, self.bounds.origin.y)));
 
 CGContextAddLineToPoint(context, self.bounds.size.width/2 -  self.timeLabel.bounds.size.width/2, LABEL_ANIMATE_DISTANCE);
 NSLog(@"Point: %@", NSStringFromCGPoint(CGPointMake(self.bounds.size.width/2 -  self.timeLabel.bounds.size.width/2, LABEL_ANIMATE_DISTANCE)));
 
 CGContextClosePath(context);
 CGContextStrokePath(context);
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
