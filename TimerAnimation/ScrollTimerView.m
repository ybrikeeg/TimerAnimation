//
//  ScrollTimerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "ScrollTimerView.h"
#import "ScaleView.h"

@interface ScrollTimerView ()
@end
@implementation ScrollTimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        
        self.timerLabel = [[UILabel alloc] initWithFrame:frame];
        self.timerLabel.text = @"00:00";
        self.timerLabel.font = [UIFont fontWithName:@"Verdana" size:20.0f];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timerLabel];
    }
    return self;
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
