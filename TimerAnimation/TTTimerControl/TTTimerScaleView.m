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
@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic) int totalMinsInScale;
@property (nonatomic) int minsFromPreviousHours;
@property (nonatomic) float scaleWidth;
@property (nonatomic) float pointsForHour;
@property (nonatomic) float pointsFromPreviousHour;

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
        
        
        self.trianglePoint = CGPointMake(self.bounds.size.width - SCALE_INSET, SCALE_INSET);
        
        
        UILabel *helper = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * .30f, self.bounds.size.width, self.bounds.size.height)];
        helper.text = @"Scrub horiztonally to adjust start time";
        helper.textAlignment = NSTextAlignmentCenter;
        helper.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:helper];
        
        
        
        [self initializeTimeMarkers];
        
        
        //makes sure that if the time changes while in the animation, everything adjusts accordingly
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void)initializeTimeMarkers
{
    self.totalMinsInScale = MAX_MINUTES;//scale will always contain totalHoursInScale * 60....duhh

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];//minutes past the last hour (ex 3:46 -> 46)
    
    self.scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;
    
    NSLog(@"minsFromPreviousHours: %d", self.minsFromPreviousHours);
    NSLog(@"scaleWidth: %f", self.scaleWidth);
    NSLog(@"totalMinsInScale: %d", self.totalMinsInScale);
    NSLog(@"pointsForHour: %f", self.pointsForHour);
    NSLog(@"pointsFromPreviousHour: %f", self.pointsFromPreviousHour);
    
    
    self.labelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.totalMinsInScale; i++){
        
        UILabel *closestHour = [[UILabel alloc] init];
        [dateFormatter setDateFormat:@"h"];//h:m a for am/pm
        closestHour.text = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-i * 60 * 60]];
        closestHour.backgroundColor = [UIColor redColor];
        closestHour.textAlignment = NSTextAlignmentRight;
        closestHour.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:closestHour];
        [closestHour sizeToFit];
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, 20);
        closestHour.alpha = 0.0;
        [self.labelArray addObject:closestHour];
    }
    
    NSLog(@"\n\n");
}
- (NSString *)timeToString:(NSDate *)d{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];//h:m a for am/pm
    return [dateFormatter stringFromDate: d];
}

- (void)updateTimeMarkers
{
    self.scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;
    
    NSLog(@"minsFromPreviousHours: %d", self.minsFromPreviousHours);
    NSLog(@"scaleWidth: %f", self.scaleWidth);
    NSLog(@"totalMinsInScale: %d", self.totalMinsInScale);
    NSLog(@"pointsForHour: %f", self.pointsForHour);
    NSLog(@"pointsFromPreviousHour: %f", self.pointsFromPreviousHour);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *closestHour = [self.labelArray objectAtIndex:i];
        [dateFormatter setDateFormat:@"h"];//h:m a for am/pm
        closestHour.text = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-i * 60 * 60]];
        [closestHour sizeToFit];
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, 20);
    }
    
}

-(void)updateTime:(NSTimer *)timer{
    self.fixedTimeLabel.text = [self timeToString:[NSDate date]];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    if (self.minsFromPreviousHours != [[dateFormatter stringFromDate: [NSDate date]] intValue]){
        self.totalMinsInScale++;//scale will always contain totalHoursInScale * 60....duhh
        
        NSLog(@"changing");
        self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];
        [self updateTimeMarkers];
    }
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
    
    
    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *label = [self.labelArray objectAtIndex:i];
            /*
        //checks that the labels are properly placed
        if (label.center.x > self.slidingTimeLabel.center.x){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            [label setAlpha:1.0f];
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            [label setAlpha:0.0f];
            [UIView commitAnimations];
        }
      */
        //uncomment this when not testing
        
        if (label.frame.origin.x > self.slidingTimeLabel.frame.origin.x + self.slidingTimeLabel.frame.size.width){
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            [label setAlpha:1.0f];
            [UIView commitAnimations];

        } else {
            
            //if (CGRectIntersectsRect(self.slidingTimeLabel.frame, label.frame)){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.1f];
                [label setAlpha:0.0f];
                [UIView commitAnimations];
                
            //}
            
        }
        
    }
    
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
