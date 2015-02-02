//
//  IntensiteitViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "IntensiteitViewController.h"

@interface IntensiteitViewController ()

@end

@implementation IntensiteitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHue:4 saturation:78 brightness:89 alpha:1.0]];
    [self setBackgroundColorHue:4 saturation:78 brightness:89];
    [self.maxButton setSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Background
- (void)setBackgroundColorHue:(float)hue saturation:(float)saturation brightness:(float)brightness
{
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.backgroundColor = color.CGColor;
    backgroundLayer.frame = self.view.frame;
    
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];
}


- (IBAction)minButton:(id)sender
{
    [self.minButton setSelected:YES];
    [self.maxButton setSelected:NO];
}

- (IBAction)maxButton:(id)sender
{
    [self.minButton setSelected:NO];
    [self.maxButton setSelected:YES];
}
@end
