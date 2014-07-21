//
//  ScrollTimerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "ScrollTimerView.h"
#import "ScaleView.h"
#import "ContainerView.h"

@interface ScrollTimerView ()
@end
@implementation ScrollTimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [ContainerView colorWithHexString:@"1E4F6A"];
        
        self.timerLabel = [[UILabel alloc] initWithFrame:frame];
        self.timerLabel.text = @"0 hrs 0 mins";
        self.timerLabel.font = [UIFont fontWithName:@"Verdana" size:24.0f];
        self.timerLabel.textColor = [ContainerView colorWithHexString:@"CDDEC6"];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timerLabel];
    }
    return self;
}

@end
