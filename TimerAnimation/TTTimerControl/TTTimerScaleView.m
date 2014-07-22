//
//  ScaleView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerScaleView.h"
#import "TTTimerControl.h"
#import "Constants.h"

@interface TTTimerScaleView ()
@property (nonatomic, strong) UILabel *fixedTimeLabel;
@end

@implementation TTTimerScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [TTTimerControl colorWithHexString:@"4DAAAB"];
        
        self.fixedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        self.fixedTimeLabel.text = [self timeToString:[NSDate date]];
        self.fixedTimeLabel.textAlignment = NSTextAlignmentRight;
        self.fixedTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.fixedTimeLabel];
        [self.fixedTimeLabel sizeToFit];
        self.fixedTimeLabel.frame = CGRectMake(self.bounds.size.width - self.fixedTimeLabel.bounds.size.width, 0, self.fixedTimeLabel.bounds.size.width, self.fixedTimeLabel.bounds.size.height);
        
        
        self.slidingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        self.slidingTimeLabel.text = [self timeToString:[NSDate date]];
        self.slidingTimeLabel.textAlignment = NSTextAlignmentRight;
        self.slidingTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.slidingTimeLabel];
        [self.slidingTimeLabel sizeToFit];
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
        [self.slidingTimeLabel sizeToFit];

        
        self.trianglePoint = CGPointMake(SCALE_INSET, SCALE_INSET);
        
        
        UILabel *helper = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * .30f, self.bounds.size.width, self.bounds.size.height)];
        helper.text = @"Scrub horiztonally to adjust start time";
        helper.textAlignment = NSTextAlignmentCenter;
        helper.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:helper];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        

        
        
        int totalHoursInScale = 4;//max of 4 hours in scale (only 3 hours 59 mins in scale)

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
        int minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];//minutes past the last hour (ex 3:46 -> 46)
        
        float scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
        int totalMinsInScale = (totalHoursInScale - 1) * 60 + minsFromPreviousHours;//3 hours plus remaining minutes
        float pointsForHour = (float)(scaleWidth / totalMinsInScale) * 60;//number of points each hour is
        float pointsFromPreviousHour = (float)(minsFromPreviousHours / (float)60) * pointsForHour;
        
        NSLog(@"minsFromPreviousHours: %d", minsFromPreviousHours);
        NSLog(@"scaleWidth: %f", scaleWidth);
        NSLog(@"totalMinsInScale: %d", totalMinsInScale);
        NSLog(@"pointsForHour: %f", pointsForHour);
        NSLog(@"pointsFromPreviousHour: %f", pointsFromPreviousHour);
        
        NSLog(@"\n\n");

    }
    return self;
}

- (NSString *)timeToString:(NSDate *)d{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];//h:m a for am/pm
    return [dateFormatter stringFromDate: d];
}

-(void)updateTime:(NSTimer *)timer{
    self.fixedTimeLabel.text = [self timeToString:[NSDate date]];
}
- (void)setTrianglePoint:(CGPoint)trianglePoint
{
    if (trianglePoint.x < SCALE_INSET) return;
    if (trianglePoint.x > self.bounds.size.width - SCALE_INSET) return;
    
    
    
    self.slidingTimeLabel.center = CGPointMake(_trianglePoint.x, self.slidingTimeLabel.bounds.size.height/2);

    if (self.slidingTimeLabel.frame.origin.x < 0){
        //NSLog(@"Whoa left");
        self.slidingTimeLabel.frame = CGRectMake(0, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    } else if (self.slidingTimeLabel.frame.origin.x + self.slidingTimeLabel.bounds.size.width > self.bounds.size.width){
        //NSLog(@"Whoa right");
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);

    }
    

    _trianglePoint = CGPointMake(trianglePoint.x, SCALE_INSET);

    
    if (CGRectIntersectsRect(self.slidingTimeLabel.frame, self.fixedTimeLabel.frame)){
        self.fixedTimeLabel.alpha = 0.20f;
    } else{
        self.fixedTimeLabel.alpha = 1.0f;

    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    //draws the scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, SCALE_INSET, START_OFFSET);
    CGContextAddLineToPoint(context, SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET);
    //CGContextAddArc(context, SCALE_INSET + CORNER_RADIUS, SCALE_INSET + CORNER_RADIUS, CORNER_RADIUS, M_PI, -M_PI/2, 0);
    //CGContextAddLineToPoint(context, SCALE_INSET + CORNER_RADIUS, SCALE_INSET);
    //CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET - CORNER_RADIUS, SCALE_INSET);
    //CGContextAddArc(context, self.bounds.size.width - SCALE_INSET - CORNER_RADIUS, SCALE_INSET + CORNER_RADIUS, CORNER_RADIUS, -M_PI/2, 0, 0);
    //CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET);
    
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    [self.slidingTimeLabel sizeToFit];

    
    /*
    //draws the scale
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, SCALE_INSET, START_OFFSET);
    CGContextAddArc(context, SCALE_INSET + CORNER_RADIUS, SCALE_INSET + CORNER_RADIUS, CORNER_RADIUS, M_PI, -M_PI/2, 0);
    CGContextAddLineToPoint(context, SCALE_INSET + CORNER_RADIUS, SCALE_INSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET - CORNER_RADIUS, SCALE_INSET);
    CGContextAddArc(context, self.bounds.size.width - SCALE_INSET - CORNER_RADIUS, SCALE_INSET + CORNER_RADIUS, CORNER_RADIUS, -M_PI/2, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET);

    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    //draws the tick marks
    
    for (int i = 1; i < 4; i++){
        CGContextMoveToPoint(context, SCALE_INSET + i * (self.bounds.size.width - 2*SCALE_INSET) / 4, SCALE_INSET);
        CGContextAddLineToPoint(context, SCALE_INSET + i * (self.bounds.size.width - 2*SCALE_INSET) / 4, SCALE_INSET + 5);
        CGContextStrokePath(context);
    }
    */
    //draws the triangle
    CGContextMoveToPoint(context, self.trianglePoint.x, START_OFFSET);
    CGContextAddLineToPoint(context, self.trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, self.trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH - TRIANGLE_OPPOSITE_SIDE + SCALE_LINE_WIDTH/2);
    CGContextAddLineToPoint(context, self.trianglePoint.x + .5 * TRIANGLE_SIDE_LENGTH, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2);
    CGContextAddLineToPoint(context, self.trianglePoint.x - (.5 * TRIANGLE_SIDE_LENGTH), START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2);
    CGContextClosePath(context);

    CGContextSetFillColorWithColor(context, [TTTimerControl colorWithHexString:@"CDDEC6"].CGColor);
    CGContextFillPath(context);
    
}


@end
