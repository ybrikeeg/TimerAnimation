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
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"h:mm"];//h:m a for am/pm

        self.fixedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        self.fixedTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
        self.fixedTimeLabel.text = [self.fixedTimeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%c", [self truncateAmPm: [dateFormatter stringFromDate:[NSDate date]]]]];
        self.fixedTimeLabel.textAlignment = NSTextAlignmentRight;
        self.fixedTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.fixedTimeLabel];
        [self.fixedTimeLabel sizeToFit];
        self.fixedTimeLabel.frame = CGRectMake(self.bounds.size.width - self.fixedTimeLabel.bounds.size.width, 0, self.fixedTimeLabel.bounds.size.width, self.fixedTimeLabel.bounds.size.height);

        
        self.slidingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        [dateFormatter setDateFormat:@"h:mm"];//h:m a for am/pm
        self.slidingTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
        self.slidingTimeLabel.text = [self.slidingTimeLabel.text stringByAppendingString:[NSString stringWithFormat:@" %c", [self truncateAmPm: [dateFormatter stringFromDate:[NSDate date]]]]];
        self.slidingTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.slidingTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.slidingTimeLabel];
        [self.slidingTimeLabel sizeToFit];
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
        
        
        self.trianglePoint = CGPointMake(self.bounds.size.width, SCALE_INSET);
        
        
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
    self.totalMinsInScale = DEFAULT_MINS_IN_SCALE;//scale will always contain totalHoursInScale * 60....duhh

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];//minutes past the last hour (ex 3:46 -> 46)
    
    self.scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;
    
    self.labelArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < 24; i++){
        UILabel *closestHour = [[UILabel alloc] init];
        [dateFormatter setDateFormat:@"h"];//h:m a for am/pm
        closestHour.text = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-i * 60 * 60]];
        [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
        closestHour.text = [closestHour.text stringByAppendingString:[NSString stringWithFormat:@"%c", [self truncateAmPm: [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-i * 60 * 60]]]]];
        //closestHour.backgroundColor = [UIColor redColor];
        closestHour.textAlignment = NSTextAlignmentRight;
        closestHour.font = [UIFont fontWithName:@"Verdana" size:12.0f];
        [self addSubview:closestHour];
        [closestHour sizeToFit];
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH - closestHour.bounds.size.height/2);
        closestHour.alpha = 1.0;
        [self.labelArray addObject:closestHour];
    }
}

- (NSString *)timeToString:(NSDate *)d{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];//h:m a for am/pm
    return [dateFormatter stringFromDate: d];
}

- (char )truncateAmPm: (NSString *)time
{
    return [time characterAtIndex:0];
}

- (void)updateTimeMarkers
{
    self.scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *closestHour = [self.labelArray objectAtIndex:i];
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH - closestHour.bounds.size.height/2);
    }
}

- (NSString *)dateFormatter: (NSDate *) date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];//h:m a for am/pm
    return [dateFormatter stringFromDate:date];
}

- (void)updateSlidingLabel:(int)mins
{
    self.trianglePoint = CGPointMake((self.bounds.size.width - 2*SCALE_INSET) * (((float)self.totalMinsInScale - mins) / (float)self.totalMinsInScale) + SCALE_INSET, SCALE_INSET);
    NSLog(@"tri point: %@", NSStringFromCGPoint(_trianglePoint));
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm"];//h:m a for am/pm
    self.slidingTimeLabel.text = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-mins * 60]];
    [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
    self.slidingTimeLabel.text = [self.slidingTimeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%c", [self truncateAmPm: [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-mins * 60]]]]];
}

- (void)setTotalMinsInScale:(int)totalMinsInScale
{
    if (totalMinsInScale > MAX_MINUTES){
        _totalMinsInScale = MAX_MINUTES;
        return;
    }
    _totalMinsInScale = totalMinsInScale;
  
    self.slidingTimeLabel.text = [self timeToString:[[NSDate date] dateByAddingTimeInterval:-_totalMinsInScale * 60]];
    [self updateTimeMarkers];
}

-(void)updateTime:(NSTimer *)timer
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    
    if (self.minsFromPreviousHours != [[dateFormatter stringFromDate: [NSDate date]] intValue]){

        [dateFormatter setDateFormat:@"h:mm"];//h:m a for am/pm
        
        self.fixedTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
        self.fixedTimeLabel.text = [self.fixedTimeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%c", [self truncateAmPm: [dateFormatter stringFromDate:[NSDate date]]]]];
        [self.fixedTimeLabel sizeToFit];
        
        [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm

        self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];
        [self updateTimeMarkers];
    }
}

- (void)updateTimeLabels
{
    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *label = [self.labelArray objectAtIndex:i];
        if (label.frame.origin.x > SCALE_INSET){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            [label setAlpha:1.0f];
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.11f];
            [label setAlpha:0.0f];
            [UIView commitAnimations];
        }
    }
}
- (void)updateSlider{
    if (self.slidingTimeLabel.frame.origin.x < 0){
        self.slidingTimeLabel.frame = CGRectMake(0, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    } else if (self.slidingTimeLabel.frame.origin.x + self.slidingTimeLabel.bounds.size.width > self.bounds.size.width){
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    }
}
- (void)setTrianglePoint:(CGPoint)trianglePoint
{
    [self updateTimeLabels];

    
    if (trianglePoint.x < SCALE_INSET) {
        self.totalMinsInScale += self.dx;
        self.mins += self.dx;
        _trianglePoint = CGPointMake(SCALE_INSET, SCALE_INSET);
        [self updateSlider];
        NSLog(@"tri point1: %@", NSStringFromCGPoint(_trianglePoint));

        return;
    }
    
    if (trianglePoint.x > self.bounds.size.width - SCALE_INSET){
        _trianglePoint = CGPointMake(self.bounds.size.width, SCALE_INSET);
        [self updateSlider];
        NSLog(@"tri point2: %@", NSStringFromCGPoint(_trianglePoint));

        return;
    }
    NSLog(@"sliding");
    self.slidingTimeLabel.center = CGPointMake(_trianglePoint.x, self.slidingTimeLabel.bounds.size.height/2);
    
    [self updateSlider];

    
    _trianglePoint = CGPointMake(trianglePoint.x, SCALE_INSET);

    //fades the current time label out if the two labels intersect
    if (CGRectIntersectsRect(self.slidingTimeLabel.frame, self.fixedTimeLabel.frame)){
        self.fixedTimeLabel.alpha = 0.20f;
    } else{
        self.fixedTimeLabel.alpha = 1.0f;
    }
    NSLog(@"tri point3: %@", NSStringFromCGPoint(_trianglePoint));

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //draws the scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [TTTimerControl colorWithHexString:@"FEAA3A"].CGColor);
    CGContextFillRect(context, CGRectMake(_trianglePoint.x, START_OFFSET + TIME_BLOCK_OFFSET, self.bounds.size.width - SCALE_INSET - _trianglePoint.x, SCALE_SIDE_LENGTH - TIME_BLOCK_OFFSET));

    //draws the scale
    CGContextMoveToPoint(context, SCALE_INSET, START_OFFSET);
    CGContextAddLineToPoint(context, SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET);
    
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    [self.slidingTimeLabel sizeToFit];
    

    //draws the triangle
    CGContextMoveToPoint(context, self.trianglePoint.x, START_OFFSET);
    CGContextAddLineToPoint(context, self.trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH);
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [TTTimerControl colorWithHexString:@"1E4F6A"].CGColor);
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    
    //draws the triangle
    CGContextMoveToPoint(context, self.trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH - TRIANGLE_OPPOSITE_SIDE + SCALE_LINE_WIDTH/2);
    CGContextAddLineToPoint(context, self.trianglePoint.x + .5 * TRIANGLE_SIDE_LENGTH, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2);
    CGContextAddLineToPoint(context, self.trianglePoint.x - (.5 * TRIANGLE_SIDE_LENGTH), START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [TTTimerControl colorWithHexString:@"CDDEC6"].CGColor);
    CGContextFillPath(context);
    
}


@end
