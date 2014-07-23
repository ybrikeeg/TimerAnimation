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
@property (nonatomic) float pointsForVisibleHours;
@end

@implementation TTTimerScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [TTTimerControl colorWithHexString:@"4DAAAB"];
        
        self.fixedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        self.fixedTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[NSDate date]]];
        self.fixedTimeLabel.textAlignment = NSTextAlignmentRight;
        self.fixedTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.fixedTimeLabel];
        [self.fixedTimeLabel sizeToFit];
        self.fixedTimeLabel.frame = CGRectMake(self.bounds.size.width - self.fixedTimeLabel.bounds.size.width, 0, self.fixedTimeLabel.bounds.size.width, self.fixedTimeLabel.bounds.size.height);
        
        
        self.slidingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 20)];
        self.slidingTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[NSDate date]]];
        self.slidingTimeLabel.textAlignment = NSTextAlignmentRight;
        self.slidingTimeLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
        [self addSubview:self.slidingTimeLabel];
        [self.slidingTimeLabel sizeToFit];
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
        
        
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

/*
 *  Creates all the hourly markers, sets the hourly marker positioning properties
 */
- (void)initializeTimeMarkers
{
    self.totalMinsInScale = DEFAULT_MINS_IN_SCALE;//scale will always contain totalHoursInScale * 60....duhh
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];//minutes past the last hour (ex 3:46 -> 46)
    
    self.scaleWidth = self.bounds.size.width - 2*SCALE_INSET;//number of points in scale
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;
    self.pointsForVisibleHours = self.pointsForHour;
    self.labelArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < 24; i++){
        UILabel *closestHour = [[UILabel alloc] init];
        [dateFormatter setDateFormat:@"h"];//h:m a for am/pm
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-i * 60 * 60];
        closestHour.text = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], [self truncateDate:date]];
        //closestHour.backgroundColor = [UIColor redColor];
        closestHour.textAlignment = NSTextAlignmentRight;
        closestHour.font = [UIFont fontWithName:@"Verdana" size:12.0f];
        [self addSubview:closestHour];
        [closestHour sizeToFit];
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH - closestHour.bounds.size.height/2);
        closestHour.alpha = 0.0;
        [self.labelArray addObject:closestHour];
    }
}

/*
 *  Returns A for am, P for pm
 */
- (NSString *)truncateDate:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"a"];//h:m a for am/pm
    return [NSString stringWithFormat:@"%c", [[dateFormatter stringFromDate:date] characterAtIndex:0]];
}

/*
 *  Returns a string of the time followed by a one char am/pm indicator
 */
- (NSString *)timeToString:(NSDate *)date{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm"];//h:m a for am/pm
    NSString *returnString = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@%@", returnString, [self truncateDate:date]];
}

/*
 *  This updates all the variables that are used to determine the
 *  position of the hourly markers. Called everytime the time in
 *  scale changes
 */
- (void)updateTimeMarkers
{
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;

    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *closestHour = [self.labelArray objectAtIndex:i];
        if (i % (int)pow(2, (int)(30.0f/self.pointsForHour)) == 0){
            closestHour.hidden = NO;
            closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH - closestHour.bounds.size.height/2);

        } else{
            closestHour.hidden = YES;
        }
    }
}

/*
 *  Updates the trianglePoint to match the users touch location. Also updates the sliding time label text
 */
- (void)updateSlidingLabel:(int)mins
{
    self.trianglePoint = CGPointMake((self.bounds.size.width - 2*SCALE_INSET) * (((float)self.totalMinsInScale - mins) / (float)self.totalMinsInScale) + SCALE_INSET, SCALE_INSET);
    self.slidingTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[[NSDate date] dateByAddingTimeInterval:-mins * 60]]];
    [self.slidingTimeLabel sizeToFit];
    
}

/*
 *  When the number of minutes changes in the scale, the sliding time label
 *  changes its text and all the hourly marker labels update their position
 */
- (void)setTotalMinsInScale:(int)totalMinsInScale
{
    if (totalMinsInScale > MAX_MINUTES){
        _totalMinsInScale = MAX_MINUTES;
        return;
    }
    _totalMinsInScale = totalMinsInScale;
    
    self.slidingTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[[NSDate date] dateByAddingTimeInterval:-_totalMinsInScale * 60]]];
    [self.slidingTimeLabel sizeToFit];

    [self updateTimeMarkers];
}

/*
 *  This is a timer selector called every second to check if the current
 *  time has increased since the user has touched down. If time has
 *  changed, then the fixed label displays the current time, the mins
 *  in scale increments by one
 */
-(void)updateTime:(NSTimer *)timer{
    self.fixedTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[NSDate date]]];
    [self.fixedTimeLabel sizeToFit];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm"];//h:m a for am/pm
    if (self.minsFromPreviousHours != [[dateFormatter stringFromDate: [NSDate date]] intValue]){
        self.totalMinsInScale++;//scale will always contain totalHoursInScale * 60....duhh
        
        self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];
        [self updateTimeMarkers];
    }
}

/*
 *  Makes all hourly time markers visible that are positioned in the scale
 */
- (void)makeTimeLabelsVisibile
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

/*
 *  Setter for the trainglePoint. Sets and upper and lower bound
 *  for its x coordinate, checks if the sliding label is about to
 *  reach a side and then prevents it from going off screen, and
 *  fades the fixed label out if the two labels are overlapping
 */
- (void)setTrianglePoint:(CGPoint)trianglePoint
{
    [self makeTimeLabelsVisibile];

    if (self.totalMinsInScale > DEFAULT_MINS_IN_SCALE){
        self.totalMinsInScale += self.dx;
        self.mins += self.dx;
        [self setNeedsDisplay];
        return;
    }
    //slider is left bound
    if (trianglePoint.x <= SCALE_INSET) {
        NSLog(@"left bound");
        _trianglePoint.x = SCALE_INSET;
        self.totalMinsInScale += self.dx;
        self.mins += self.dx;
        [self setNeedsDisplay];
        return;
    }
    
    if (trianglePoint.x > self.bounds.size.width - SCALE_INSET) return;
    
    self.slidingTimeLabel.center = CGPointMake(_trianglePoint.x, self.slidingTimeLabel.bounds.size.height/2);
    
    if (self.slidingTimeLabel.frame.origin.x < 0){
        self.slidingTimeLabel.frame = CGRectMake(0, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    } else if (self.slidingTimeLabel.frame.origin.x + self.slidingTimeLabel.bounds.size.width > self.bounds.size.width){
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    }
    
    _trianglePoint = CGPointMake(trianglePoint.x, SCALE_INSET);
    
    //fades the current time label out if the two labels intersect
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
