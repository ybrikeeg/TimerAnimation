//
//  TimerViewController.m
//  TimerAnimation
//
//  Created by Gee, Kirby on 7/16/14.
//  Copyright (c) 2014 Kirby Gee - Stanford. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"
#import "TTTimerControl1.h"
#import "TTTimerDurationView.h"
#import "TTTimerViewContainer.h"

@interface TimerViewController ()
@property (strong, nonatomic) Timer *timerView;
@property (nonatomic, strong) TTTimerControl1 *timerControl;
@property (nonatomic, strong) TTTimerViewContainer *containerVelo;
@property (nonatomic, strong) TTTimerViewContainer *containerNoVelo;
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
    //self.timerView = [[Timer alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    //[self.view addSubview:self.timerView];
    
    
    
    //slide horizontally
    //self.timerControl = [[TTTimerControl1 alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80)];
    //[self.view addSubview:self.timerControl];
    
    self.containerNoVelo = [[TTTimerViewContainer alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 160 - 98/2, self.view.bounds.size.width, 160)];
    [self.view addSubview:self.containerNoVelo];
    
    
    //self.containerVelo = [[TTTimerControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80) usingVelocity: YES];
    //[self.view addSubview:self.containerVelo];
    
    NSLog(@"views laoded");
    
}

- (IBAction)startTimer:(id)sender
{
    [self.containerNoVelo startTiming];
}

- (IBAction)stopTimer:(id)sender
{
 
    [self.containerNoVelo stopTiming];
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
