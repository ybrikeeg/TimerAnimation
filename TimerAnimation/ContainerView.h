//
//  ContainerView.h
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerView : UIView

@property (nonatomic) int minutes;

+(UIColor*)colorWithHexString:(NSString*)hex;

- (id)initWithFrame:(CGRect)frame usingVelocity:(BOOL)isVelo;

@end
