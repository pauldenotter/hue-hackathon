//
//  BackgroundGradient.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "BackgroundGradient.h"

@implementation BackgroundGradient


+ (CAGradientLayer *)createGradientStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}

@end
