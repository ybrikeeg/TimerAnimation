//
//  CircularDisplay.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "CircularDisplay.h"
#import "Timer.h"

@interface CircularDisplay ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) Timer *timerView;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) int minutes;
@end

@implementation CircularDisplay

#define LABEL_SCALE_FACTOR  1.1
#define RADIUS_CLIP 0.10
#define MAX_MINUTES 1440
- (id)initWithFrame:(CGRect)frame andSuperview:(Timer*)timerView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [Timer colorWithHexString:@"068587"];
        self.layer.cornerRadius = self.bounds.size.width / 2;
        self.timeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.timeLabel.text = @"0:00";
        self.timeLabel.font = [UIFont fontWithName:@"Verdana" size:32.0f];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        //self.timeLabel.backgroundColor = [Timer colorWithHexString:@"068587"];
        [self addSubview:self.timeLabel];
        
        
        self.layer.cornerRadius = self.bounds.size.width/2;
        self.clipsToBounds = YES;

        self.centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.minutes = 0;
    }
    return self;
}

- (NSString *)convertMinutesToHoursInStringFormat:(int)minutes
{
    int hours = minutes / 60;
    int min = ((minutes % 60) / 15) * 15;
    
    return [NSString stringWithFormat:@"%d:%02d", hours, min];
}

- (void)updateTimeLabel:(int)minutes
{
    self.timeLabel.text = [self convertMinutesToHoursInStringFormat: minutes];
    self.minutes = minutes;
    [self setNeedsDisplay];
}

- (void)prepareForTimeChange
{
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.timeLabel.transform = CGAffineTransformMakeScale(1/LABEL_SCALE_FACTOR, 1/LABEL_SCALE_FACTOR);
    
    [UIView commitAnimations];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"Mins: %d", self.minutes);
    if (self.minutes < 14) return;
    if (self.minutes >= 1440){
        NSLog(@"draw complete circle");
    }
    else{
        CGContextMoveToPoint(context, self.centerPoint.x, self.centerPoint.y);
    }
    CGContextAddLineToPoint(context, self.centerPoint.x, self.centerPoint.y - (self.centerPoint.y *(1 - RADIUS_CLIP)) );
    CGContextAddArc(context, self.centerPoint.x, self.centerPoint.y, self.bounds.size.width/2 * (1 - RADIUS_CLIP), -M_PI / 2, (((float)self.minutes / (float)MAX_MINUTES) * 2*M_PI) - (M_PI / 2), 0);
    CGContextClosePath(context);
    CGFloat dashArray[] = {5, 5, 5, 5, 5, 5};
    CGContextSetLineDash(context, 0, dashArray, 0);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetFillColorWithColor(context, [Timer colorWithHexString:@"4FB99F"].CGColor);
    CGContextSetStrokeColorWithColor(context, [Timer colorWithHexString:@"F2B134"].CGColor);
    
    //CGContextStrokePath(context);
    //CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
