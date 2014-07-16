//
//  Timer.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Timer : UIView

@property (nonatomic) BOOL isTouched;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) int minutes;

- (void)prepareForTimeChange;
- (void)timeChangeEnded;

@end
