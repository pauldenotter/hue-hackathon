//
//  UIImage+ImageWithUIView.h
//  
//
//  Created by Glenn Tillemans on 04-07-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (ImageWithUIView)

+ (UIImage *)imageWithUIView:(UIView *)view;

@end
