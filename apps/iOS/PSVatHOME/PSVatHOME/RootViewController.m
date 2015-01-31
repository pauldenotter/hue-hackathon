//
//  ViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    [self.progress setBackBorderWidth: 1.0];
    [self.progress setFrontBorderWidth: 5.0];
    [self.progress setColorTable: @{
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):[UIColor whiteColor],
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):[UIColor whiteColor]
                                  }];
    
    [self.progress setText:@""];
    [self.progress setProgress:0.3];
    
    [self setBackgroundColorRed:228 green:61 blue:50 ];
    
    [self.countLabel setFont:[FontHelper regularFontOfSize:42]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColorRed:(float)red green:(float)green blue:(float)blue
{
    CAGradientLayer *backgroundLayer = [BackgroundGradient createGradientStartColor:[UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0] endColor:[UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0]];
   
    backgroundLayer.frame = self.view.frame;
    
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];
}

- (IBAction)slider:(UISlider *)sender
{
    [self.progress setProgress:sender.value];
}
@end
