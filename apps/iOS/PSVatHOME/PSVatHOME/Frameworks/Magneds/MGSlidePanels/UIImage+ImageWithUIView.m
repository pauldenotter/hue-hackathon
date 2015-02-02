//
//  UIImage+ImageWithUIView.m
//  
//
//  Created by Glenn Tillemans on 04-07-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//

#import "UIImage+ImageWithUIView.h"

@implementation UIImage (ImageWithUIView)

+ (UIImage *)imageWithUIView:(UIView *)view
{
    CGSize screenShotSize = view.bounds.size;
    UIImage *img;
    UIGraphicsBeginImageContext(screenShotSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view drawLayer:view.layer inContext:ctx];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
