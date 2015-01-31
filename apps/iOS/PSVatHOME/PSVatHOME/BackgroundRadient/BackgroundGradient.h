//
//  BackgroundGradient.h
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface BackgroundGradient : NSObject

+ (CAGradientLayer *)createGradientStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end
