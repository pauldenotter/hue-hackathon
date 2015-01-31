//
//  ViewController.m
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, assign)BOOL isStarted;

@end

@implementation RootViewController

@synthesize audioController = _audioController;
@synthesize socketController = _socketController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.audioController = [[AudioController alloc] init];    
    [self.audioController setDelegate:self];
    
    self.socketController = [[SocketController alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)audioRecognized:(AudioController *)recognizer
{
//    NSLog(@"audioRecognized");
}

-(void)audioLevelUpdated:(AudioController *)recognizer level:(float)lowPassResults
{
//    NSLog(@"audioLevelUpdated level = %f", lowPassResults);
}

- (void)audioLevelUpdated:(AudioController *)recognizer averagePower:(float)averagePower peakPower:(float)peakPower
{
//    NSLog(@"audioLevelUpdated averagePower= %f peakPower= %f", averagePower, peakPower);
    if(self.isStarted)
        [self.socketController send:[NSString stringWithFormat:@"%f;%f", averagePower, peakPower]];
}

- (IBAction)clickButton:(id)sender
{
    if(self.isStarted)
    {
        [self.button setTitle:@"START" forState:UIControlStateNormal];
        [self.socketController close];
        self.isStarted = false;
    }
    else
    {
        [self.button setTitle:@"STOP" forState:UIControlStateNormal];
        [self.socketController open];
        self.isStarted = true;
    }
}
@end
