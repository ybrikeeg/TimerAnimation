//
//  TimerViewController.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"
#import "TTTimerControl.h"

@interface TimerViewController ()
@property (strong, nonatomic) Timer *timerView;
@property (nonatomic, strong) TTTimerControl *timerControl;
@property(nonatomic, retain) NSDate *databaseDate;
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
    
    //slide vertically
    self.timerView = [[Timer alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    [self.view addSubview:self.timerView];
    
    
    
    //slide horizontally
    self.timerControl = [[TTTimerControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80)];
    [self.view addSubview:self.timerControl];
    
    NSLog(@"views laoded");
    
}





- (IBAction)startTimer:(id)sender {
    [self.timerControl startTiming];
}
- (IBAction)stopTimer:(id)sender {
 
    [self.timerControl stopTiming];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSTimeInterval remainingSec = [self.databaseDate timeIntervalSinceNow];
    //NSLog(@"Interval: %f", remainingSec);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
