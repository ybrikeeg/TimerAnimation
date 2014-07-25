//
//  ScaleView.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTimerScaleView : UIView

@property (nonatomic) float dx;

- (void)updateSlidingLabel:(int)mins;
- (void)resetScale;

@end
