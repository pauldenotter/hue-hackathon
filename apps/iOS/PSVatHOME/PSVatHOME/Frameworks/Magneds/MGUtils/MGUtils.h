//
//  MGUtils.h
//  
//
//  Created by Glenn Tillemans on 17-06-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//
//
//  MGUtils is an Utility module where all kinds of small handy
//  functions are placed in mhich are used within different modules.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum {
    MGImageResizeCrop,
    MGImageResizeFill
} MGImageResizeMode;


@interface MGUtils : NSObject

+ (BOOL)isIPad;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6P;
+ (BOOL)isIOS6;
+ (BOOL)isIOS7;
+ (BOOL)isIOS8;
+ (BOOL)isRetina;

+ (UIColor *)ColorWithRed:(float)r Green:(float)g Blue:(float)b Alpha:(float)a;

+ (id)getRootViewController;
+ (UIViewController *)topMostViewController: (UIViewController *) controller;
+ (UIViewController *)viewControllerForView:(UIView *)view;

+ (void)dismissKeyboard;

+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL)view:(UIView *)view isVisibleInScrollView:(UIScrollView *)scrollView;

+ (NSURL *)imageUrl:(NSURL *)imageUrl forImageView:(UIImageView *)imageView resizeMode:(MGImageResizeMode)resizeMode;

+ (NSString *)createJSONObject:(id)input;

+ (NSString *)encodeURL:(NSString *)string;


+ (int)calculateBannerHeigthWithWidth:(int)width;

@end
