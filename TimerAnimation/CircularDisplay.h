//
//  CircularDisplay.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"

@interface CircularDisplay : UIView

- (id)initWithFrame:(CGRect)frame andSuperview:(Timer*)timerView;

- (void)prepareForTimeChange;
- (void)timeChangeEnded;
- (void)updateTimeLabel:(int)minutes;

@end
