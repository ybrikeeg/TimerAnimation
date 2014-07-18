//
//  TTTimerControl.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/17/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTimerControl : UIView

@property (nonatomic) int minutes;
@property (nonatomic, strong) NSDate *startDate;

- (void)startTiming;
- (void)stopTiming;

@end
