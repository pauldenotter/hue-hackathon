//
//  NotificationsViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHue:4 saturation:78 brightness:89 alpha:1.0]];
    [self setBackgroundColorHue:4 saturation:78 brightness:89];
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

- (IBAction)notificationsButton:(id)sender
{
    if(self.notificationsButton.isSelected)
       [self.notificationsButton setSelected:NO];
    else
        [self.notificationsButton setSelected:YES];
}
@end
