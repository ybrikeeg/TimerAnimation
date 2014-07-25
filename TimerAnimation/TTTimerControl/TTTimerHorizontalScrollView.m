//
//  ScrollTimerView.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/18/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TTTimerHorizontalScrollView.h"
#import "TTTimerScaleView.h"
#import "TTTimerControl.h"

@interface TTTimerHorizontalScrollView ()
@end
@implementation TTTimerHorizontalScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor purpleColor];

        //self.backgroundColor = [UIColor whiteColor];
        //self.layer.cornerRadius = 12.0f;
        NSLog(@"Position: %@", NSStringFromCGRect(frame));
        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.timerLabel.text = @"0 hrs 0 mins";
        self.timerLabel.font = [UIFont systemFontOfSize:36.0f];
        //self.timerLabel.font = [UIFont fontWithName:@"Verdana" size:24.0f];
        //self.timerLabel.textColor = [TTTimerControl colorWithHexString:@"CDDEC6"];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

        [self addSubview:self.timerLabel];
    }
    return self;
}

@end
