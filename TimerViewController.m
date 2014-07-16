//
//  TimerViewController.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"

@interface TimerViewController ()
@property (weak, nonatomic) IBOutlet Timer *timerView;

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.timerView) {
        CGPoint locationInSuperView = [touch locationInView: self.view];
        NSLog(@"touch in super view: %@\n", NSStringFromCGPoint(locationInSuperView));
        
        CGPoint locationInTimerView = [touch locationInView: self.timerView];
        NSLog(@"touch in timer view: %@", NSStringFromCGPoint(locationInTimerView));
        self.timerView.touchLocation = locationInTimerView;
        [self.timerView prepareForTimeChange];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.timerView) {
        
        CGPoint locationInTimerView = [touch locationInView: self.timerView];
        //NSLog(@"touch in timer view: %@", NSStringFromCGPoint(locationInTimerView));
        self.timerView.touchLocation = locationInTimerView;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.timerView) {
        [self.timerView timeChangeEnded];
    }
}

@end
