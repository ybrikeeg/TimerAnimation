//
//  ContainerView.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTimerViewContainer : UIView

@property (nonatomic) int minutes;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) BOOL timerStarted;

- (NSDate*)startTiming;
- (void)stopTiming;

@end
