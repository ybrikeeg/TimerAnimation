//
//  ScaleView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerScaleView.h"
#import "TTTimerViewContainer.h"
#import "Constants.h"

@interface TTTimerScaleView ()
@property (nonatomic, strong) UILabel *fixedTimeLabel;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) UILabel *slidingTimeLabel;
@property (nonatomic) CGPoint trianglePoint;

@property (nonatomic) int mins;
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
        self.backgroundColor = [UIColor clearColor];
 
        self.trianglePoint = CGPointMake(self.bounds.size.width - SCALE_INSET, SCALE_INSET + SCALE_Y_OFFSET);
        
        [self createFixedAndSlidingLabels];
        [self initializeTimeMarkers];
        
        //makes sure that if the time changes while in the animation, everything adjusts accordingly
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        
    }
    return self;
}

/*
 *  Creates all the labels
 */
- (void)createFixedAndSlidingLabels
{
    self.fixedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0 + SCALE_Y_OFFSET, 60, 20)];
    self.fixedTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[NSDate date]]];
    self.fixedTimeLabel.textAlignment = NSTextAlignmentRight;
    self.fixedTimeLabel.alpha = LABEL_OVERLAP_ALPHA;
    [self addSubview:self.fixedTimeLabel];
    [self.fixedTimeLabel sizeToFit];
    self.fixedTimeLabel.frame = CGRectMake(self.bounds.size.width - self.fixedTimeLabel.bounds.size.width - SCALE_INSET, 0 + SCALE_Y_OFFSET, self.fixedTimeLabel.bounds.size.width, self.fixedTimeLabel.bounds.size.height);
    
    
    self.slidingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0 + SCALE_Y_OFFSET, 60, 20)];
    self.slidingTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeToString:[NSDate date]]];
    self.slidingTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.slidingTimeLabel];
    [self.slidingTimeLabel sizeToFit];
    self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width, 0 + SCALE_Y_OFFSET, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
}

/*
 *  When a timer is stopped, this removes all the labels and then adds them back to the superview
 */
- (void)resetScale
{
    [self.fixedTimeLabel removeFromSuperview];
    [self.slidingTimeLabel removeFromSuperview];
    
    [self createFixedAndSlidingLabels];
    
    for (UILabel *label in self.labelArray){
        [label removeFromSuperview];
    }
    [self.labelArray removeAllObjects];
    [self initializeTimeMarkers];
}

/*
 *  Creates all the hourly markers, sets the hourly marker positioning properties
 */
- (void)initializeTimeMarkers
{
    _totalMinsInScale = DEFAULT_MINS_IN_SCALE;//scale will always contain totalHoursInScale * 60....duhh
    
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
        closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET + 8);
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
- (void)updateHourlyMarkers
{
    self.pointsForHour = (float)(self.scaleWidth / self.totalMinsInScale) * 60;//number of points each hour is
    self.pointsFromPreviousHour = (float)(self.minsFromPreviousHours / (float)60) * self.pointsForHour;

    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *closestHour = [self.labelArray objectAtIndex:i];
        if (i % (int)pow(2, (int)(30.0f/self.pointsForHour)) == 0){
            closestHour.hidden = NO;
            closestHour.center = CGPointMake(self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, closestHour.center.y);

        } else{
            closestHour.hidden = YES;
        }
    }
}

/*
 *  Updates the trianglePoint to match the users touch location. Also 
 *  updates the sliding time label text. This is called in the TTTimerViewContainer
 */
- (void)updateSlidingLabel:(int)mins
{
    self.trianglePoint = CGPointMake((self.bounds.size.width - 2*SCALE_INSET) * (((float)self.totalMinsInScale - mins) / (float)self.totalMinsInScale) + SCALE_INSET, SCALE_INSET + SCALE_Y_OFFSET);
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

    [self updateHourlyMarkers];
}

/*
 *  If the hour changes, this updates all the hourly markers to the 
 *  correct hour
 */
- (void)increaseHourlyMarkers
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];

    for (int i = 0; i < [self.labelArray count]; i++){
        UILabel *closestHour = [self.labelArray objectAtIndex:i];
        [dateFormatter setDateFormat:@"h"];//h:m a for am/pm
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-(i - 1) * 60 * 60];
        closestHour.text = [NSString stringWithFormat:@"%@%@", [dateFormatter stringFromDate:date], [self truncateDate:date]];
        [closestHour sizeToFit];
    }
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
        _totalMinsInScale++;//scale will always contain totalHoursInScale * 60....duhh
        
        self.minsFromPreviousHours = [[dateFormatter stringFromDate: [NSDate date]] intValue];
        
        if (self.minsFromPreviousHours == 0){
            [self increaseHourlyMarkers];
        }
        [self updateHourlyMarkers];
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
            if (label.alpha < 1.0f){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.1f];
                [label setAlpha:1.0f];
                [UIView commitAnimations];
            }
        } else {
            if (label.alpha > 0.0f){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.11f];
                [label setAlpha:0.0f];
                [UIView commitAnimations];
            }
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

    //if there are more minutes in the scale than default, have the mark stick to the wall until defualt is reached
    if (_totalMinsInScale > DEFAULT_MINS_IN_SCALE){
        self.totalMinsInScale += self.dx;
        self.mins += self.dx;
        [self setNeedsDisplay];
        return;
    }
    //slider is left bound
    if (trianglePoint.x <= SCALE_INSET) {
        self.slidingTimeLabel.frame = CGRectMake(SCALE_INSET, 0 + SCALE_Y_OFFSET, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);

        _trianglePoint.x = SCALE_INSET;
        self.totalMinsInScale += self.dx;
        self.mins += self.dx;
        [self setNeedsDisplay];
        return;
    }
    
    //the slider is right bound
    if (trianglePoint.x >= self.bounds.size.width - SCALE_INSET){
        //[self.slidingTimeLabel sizeToFit];
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width - SCALE_INSET, 0 + SCALE_Y_OFFSET, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
        _trianglePoint.x = self.bounds.size.width - SCALE_INSET;
        [self setNeedsDisplay];
        return;
    }
    
    self.slidingTimeLabel.center = CGPointMake(_trianglePoint.x, self.slidingTimeLabel.bounds.size.height/2 + SCALE_Y_OFFSET);
    
    //stops moving sliding label if about to hit side
    if (self.slidingTimeLabel.frame.origin.x < SCALE_INSET){
        self.slidingTimeLabel.frame = CGRectMake(SCALE_INSET, 0 + SCALE_Y_OFFSET, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    } else if (self.slidingTimeLabel.frame.origin.x + self.slidingTimeLabel.bounds.size.width > self.bounds.size.width - SCALE_INSET){
        self.slidingTimeLabel.frame = CGRectMake(self.bounds.size.width - self.slidingTimeLabel.bounds.size.width - SCALE_INSET, 0 + SCALE_Y_OFFSET, self.slidingTimeLabel.bounds.size.width, self.slidingTimeLabel.bounds.size.height);
    }
    
    _trianglePoint = CGPointMake(trianglePoint.x, SCALE_INSET + SCALE_Y_OFFSET);
    
    //fades the current time label out if the two labels intersect
    if (CGRectIntersectsRect(self.slidingTimeLabel.frame, self.fixedTimeLabel.frame)){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.fixedTimeLabel.alpha = LABEL_OVERLAP_ALPHA;
        [UIView commitAnimations];
    } else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.fixedTimeLabel.alpha = 1.0f;
        [UIView commitAnimations];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //draws the scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draws filled rectangle
    CGContextSetRGBFillColor(context, 89.0f/255.0f, 223.0f/255.0f, 255.0f/255.0f, 1.0f);
    CGContextFillRect(context, CGRectMake(_trianglePoint.x, START_OFFSET + TIME_BLOCK_OFFSET + SCALE_Y_OFFSET, self.bounds.size.width - SCALE_INSET - _trianglePoint.x, SCALE_SIDE_LENGTH - TIME_BLOCK_OFFSET));
    
    //draws the scale
    CGContextMoveToPoint(context, SCALE_INSET, START_OFFSET + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET, START_OFFSET + SCALE_Y_OFFSET);
    
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextStrokePath(context);
    
    
    //draws the tick marks
    for (int i = 0; i < [self.labelArray count]; i++){
        if (i % (int)pow(2, (int)(30.0f/self.pointsForHour)) == 0){
            
            UILabel *label = [self.labelArray objectAtIndex:i];
            if (label.frame.origin.x > SCALE_INSET){
                context = UIGraphicsGetCurrentContext();
                CGContextMoveToPoint(context, self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET);
                CGContextAddLineToPoint(context, self.bounds.size.width - SCALE_INSET - self.pointsFromPreviousHour - i*self.pointsForHour, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET - 10);
                CGContextSetLineWidth(context, 2);
                CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
                CGContextStrokePath(context);
                
            } else {
                break;
            }
        }
    }
    
    //draws the line above the triangle
    CGContextMoveToPoint(context, _trianglePoint.x, START_OFFSET + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, _trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_Y_OFFSET);
    CGContextSetLineWidth(context, SCALE_LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    
    //draws the triangle
    CGContextMoveToPoint(context, _trianglePoint.x, START_OFFSET + SCALE_SIDE_LENGTH - TRIANGLE_OPPOSITE_SIDE + SCALE_LINE_WIDTH/2 + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, _trianglePoint.x + .5 * TRIANGLE_SIDE_LENGTH, START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2 + SCALE_Y_OFFSET);
    CGContextAddLineToPoint(context, _trianglePoint.x - (.5 * TRIANGLE_SIDE_LENGTH), START_OFFSET + SCALE_SIDE_LENGTH + SCALE_LINE_WIDTH/2 + SCALE_Y_OFFSET);
    CGContextClosePath(context);
    
    CGContextSetRGBFillColor(context, 232.0f/255.0f, 230.0f/255.0f, 231.0f/255.0f, 1.0f);
    CGContextFillPath(context);
}
@end