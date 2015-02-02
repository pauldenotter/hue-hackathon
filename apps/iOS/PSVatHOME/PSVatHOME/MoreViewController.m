//
//  MoreViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "MoreViewController.h"
#import "FontHelper.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHue:4 saturation:78 brightness:89 alpha:1.0]];
    [self setBackgroundColorHue:4 saturation:78 brightness:89];
    
    [self.psvLabel setFont:[FontHelper regularFontOfSize:14]];
    [self.hueLabel setFont:[FontHelper regularFontOfSize:14]];
    [self.ambilightLabel setFont:[FontHelper regularFontOfSize:14]];
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
- (IBAction)psvButton:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/nl/app/psv-de-officiele-app/id957349915?l=en&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)hueButton:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/nl/app/philips-hue/id557206189?l=en&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)abmilightButton:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/nl/app/ambilight+hue/id640081408?l=en&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
@end
