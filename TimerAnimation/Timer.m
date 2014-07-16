//
//  Timer.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "Timer.h"

@interface Timer ()
@property (nonatomic, retain)UILabel *timeLabel;

@end
@implementation Timer

#define LABEL_SCALE_FACTOR  1.2
#define MAX_MINUTES 1440 //24 * 60
#define LOWER_BOUND 0.05 //hard to reach the bottom of the screen, so this shortens the touch boundry by LOWER_BOUND percent
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void) awakeFromNib
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.timeLabel.text = @"First text";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont fontWithName:@"Verdana" size:32.0f];
    [self addSubview:self.timeLabel];
    
    NSLog(@"Size: %@", NSStringFromCGRect(self.bounds));
}


- (void)prepareForTimeChange
{
    NSLog(@"preping for time change");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.timeLabel.transform = CGAffineTransformMakeScale(LABEL_SCALE_FACTOR, LABEL_SCALE_FACTOR);
    
    [UIView commitAnimations];
}

- (void)timeChangeEnded
{
    NSLog(@"end of time change");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.timeLabel.transform = CGAffineTransformMakeScale(1/LABEL_SCALE_FACTOR, 1/LABEL_SCALE_FACTOR);
    
    [UIView commitAnimations];
}
- (NSString *)convertMinutesToHoursInStringFormat
{
    int hours = self.minutes / 60;
    int min = ((self.minutes % 60) / 15) * 15;
    
    return [NSString stringWithFormat:@"%d:%02d", hours, min];
}
- (void)setMinutes:(int)minutes
{
    if (minutes <= MAX_MINUTES){
        _minutes = minutes;
    } else {
        _minutes = MAX_MINUTES;
    }
}
- (void)setTouchLocation:(CGPoint)touchLocation
{
    if (touchLocation.y > 0){
        NSLog(@"touch location changing");
        _touchLocation = touchLocation;
        self.minutes = (touchLocation.y / ((self.bounds.size.height * (1 - LOWER_BOUND)))) * MAX_MINUTES;
    
        self.timeLabel.text = [self convertMinutesToHoursInStringFormat];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
