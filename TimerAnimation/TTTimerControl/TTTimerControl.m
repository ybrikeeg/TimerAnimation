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
@property (nonatomic, strong) UIView *borderView;
@end

@implementation TTTimerControl


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor greenColor];
        //self.alpha = 0.75f;
        self.backgroundColor = [UIColor clearColor];
        
        self.scroll = [[TTTimerHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height/2)];
        [self addSubview:self.scroll];
        
        self.scale = [[TTTimerScaleView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height/2)];
        [self addSubview:self.scale];
        
        
        self.borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height/2)];
        [self addSubview:self.borderView];
        
        self.borderView.layer.cornerRadius = CORNER_RADIUS;
        self.borderView.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        self.borderView.layer.borderWidth = 2.0f;
        
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDoMethod)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        [self.scale addGestureRecognizer: swipeGesture];
        
        
        //self.scale.hidden = YES;
        [self sendSubviewToBack:self.scroll];
        
        [self sendSubviewToBack:self.scale];
        [self sendSubviewToBack:self.borderView];
        
        self.minutes = 0;
    }
    return self;
}


- (void)swipeToDoMethod
{
    [self moveScaleView:-80];
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
        self.startDate = nil;
        [self.scale resetScale];
        self.minutes = 0;
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
    if (!self.timerStarted){
        self.timerStarted = YES;
        self.startDate = [NSDate date];
        self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        
        //round minutes to nearest multiple of 15
        int hours = self.minutes / 60;
        int min = ((self.minutes % 60) / MINUTE_ROUNDING_TO_NEAREST) * MINUTE_ROUNDING_TO_NEAREST;
        
        int tempMin = hours * 60 + min;
        self.minutes = tempMin;
        self.startDate = [self.startDate dateByAddingTimeInterval:-tempMin * 60];
        [self moveScaleView:-80];
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
    [UIView setAnimationDuration:.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.scale.frame = CGRectMake(0, self.bounds.origin.y - dist, self.bounds.size.width, self.scale.frame.size.height);
    if (dist >= 0){
        self.borderView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } else {
        self.borderView.frame = CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height/2);
    }
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!self.timerStarted){
        UITouch *touch = [[event allTouches] anyObject];
        NSLog(@"Touched view  %@",[touch.view class] );
        
        self.touchLocation = [touch locationInView:self];
        
        if ([touch.view class] == [self.scroll class]){
            [self moveScaleView:0];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        //[self moveScaleView:-80];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.timerStarted){
        //[self moveScaleView:-80];
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
