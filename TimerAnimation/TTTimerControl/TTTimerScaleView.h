//
//  ScaleView.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTimerScaleView : UIView
@property (nonatomic) CGPoint trianglePoint;
@property (nonatomic, strong) UILabel *slidingTimeLabel;

@property (nonatomic) int mins;
@property (nonatomic) float dx;

- (void)updateSlidingLabel:(int)mins;

@end
