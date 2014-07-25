//
//  ContainerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerViewContainer.h"
#import "TTTimerScaleView.h"
#import "TTTimerDurationView.h"
#import "Constants.h"

@interface TTTimerViewContainer ()
@property (nonatomic, strong) TTTimerScaleView *scale;
@property (nonatomic, strong) TTTimerDurationView *scroll;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic, strong) NSTimer *mainTimer;
@property (nonatomic) CGPoint firstTouch;
@property (nonatomic, strong) UIView *borderView;
@end

@implementation TTTimerViewContainer


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.scroll = [[TTTimerDurationView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height/2)];
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
    //move scale view up top or back down
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
@end
