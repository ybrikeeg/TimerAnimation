//
//  Timer.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "Timer.h"
#import "CircularDisplay.h"

@interface Timer ()
//@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, strong)CircularDisplay *circleView;
@property (nonatomic, strong)NSTimer *pulseTimer;
@end
@implementation Timer

#define MAX_MINUTES 1440 //24 * 60
#define LOWER_BOUND 0.05 //hard to reach the bottom of the screen, so this shortens the touch boundry by LOWER_BOUND percent
#define CIRCLE_DIAMETER 140
#define LABEL_SCALE_FACTOR  1.1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init");
        self.backgroundColor = [Timer colorWithHexString:@"112F41"];

        self.minutes = 0;
        self.circleView = [[CircularDisplay alloc] initWithFrame:CGRectMake((self.bounds.size.width / 2) - (CIRCLE_DIAMETER / 2), 0 - (CIRCLE_DIAMETER / 2), CIRCLE_DIAMETER, CIRCLE_DIAMETER) andSuperview: self];
        [self addSubview:self.circleView];
        
        self.layer.cornerRadius = 25;

        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)targetMethod:(NSTimer *)timer
{
    NSLog(@"pulse");
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration = 0.3;
    theAnimation.autoreverses = YES;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    theAnimation.toValue = [NSNumber numberWithFloat:0.8];
    [self.layer addAnimation:theAnimation forKey:@"animateOpacity"];
}

- (void) awakeFromNib//use this if view created in storyboard
{
    NSLog(@"Size: %@", NSStringFromCGRect(self.bounds));
}


- (void)prepareForTimeChange
{
    if (self.pulseTimer){
        [self.pulseTimer invalidate];
        self.pulseTimer = nil;
    }
    [self.circleView prepareForTimeChange];
    
    NSLog(@"preping for time change");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.circleView.transform = CGAffineTransformMakeScale(LABEL_SCALE_FACTOR, LABEL_SCALE_FACTOR);
    
    [UIView commitAnimations];
     

}

- (void)timeChangeEnded
{
    [self.circleView timeChangeEnded];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.circleView.transform = CGAffineTransformMakeScale(1/LABEL_SCALE_FACTOR, 1/LABEL_SCALE_FACTOR);
    
    [UIView commitAnimations];
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
        _touchLocation = touchLocation;
        self.minutes = (touchLocation.y / ((self.bounds.size.height * (1 - LOWER_BOUND)))) * MAX_MINUTES;
        [self.circleView updateTimeLabel: self.minutes];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
