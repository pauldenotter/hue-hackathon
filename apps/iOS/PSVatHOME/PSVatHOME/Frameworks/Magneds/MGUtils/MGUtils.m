//
//  MGUtils.m
//  
//
//  Created by Glenn Tillemans on 17-06-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//

#import "MGUtils.h"



@implementation MGUtils

#pragma mark - Device Selection
+ (BOOL)isIPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL)isIPhone5
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568);
}

+ (BOOL)isIPhone6
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667);
}


+ (BOOL)isIPhone6P
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736);
}

#pragma mark - Software Versions
+ (BOOL)isIOS6
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0;
}

+ (BOOL)isIOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0;
}

+ (BOOL)isIOS8
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

#pragma mark - Screen resolution
+ (BOOL)isRetina
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

#pragma mark - Colors

+ (UIColor *)ColorWithRed:(float)r Green:(float)g Blue:(float)b Alpha:(float)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

#pragma mark - ViewController Selection
+ (id)getRootViewController
{
    //    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //    if (window.windowLevel != UIWindowLevelNormal)
    //    {
    //        NSArray *windows = [[UIApplication sharedApplication] windows];
    //        for(window in windows)
    //        {
    //            if (window.windowLevel == UIWindowLevelNormal)
    //            {
    //                break;
    //            }
    //        }
    //    }
    //
    //    for (UIView *subView in [window subviews])
    //    {
    //        UIResponder *responder = [subView nextResponder];
    //        if([responder isKindOfClass:[UIViewController class]])
    //        {
    //            return [self topMostViewController: (UIViewController *) responder];
    //        }
    //    }
    //
    //    return nil;
    
    return [self topMostViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}



#pragma mark - Dismiss Keyboard
+ (void)dismissKeyboard
{
    [self globalResignFirstResponder];
}

+ (void)globalResignFirstResponder
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews])
    {
        [self globalResignFirstResponderRec:view];
    }
}

+ (void)globalResignFirstResponderRec:(UIView*) view
{
    if ([view respondsToSelector:@selector(resignFirstResponder)])
    {
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews])
    {
        [self globalResignFirstResponderRec:subview];
    }
}

#pragma mark - Validations
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSDictionary *)MagnedsBundle
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Magneds"];
}

+ (BOOL)view:(UIView *)view isVisibleInScrollView:(UIScrollView *)scrollView
{
    CGPoint viewPoint = view.frame.origin;
    CGPoint scrollviewPoint = scrollView.contentOffset;
    
//    if(CGPointEqualToPoint(scrollviewPoint, viewPoint))
    if(viewPoint.x - scrollviewPoint.x < 320/2-10)
        return YES;
    
    return NO;
}

#pragma mark - Date Formatting
+ (NSString *)formatDate:(NSString *)input
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[input integerValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:fromDate];
    
    return dateString;
}

+ (NSString *)formatMySQLDate:(NSString *)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [dateFormatter dateFromString:input];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:fromDate];
    
    return dateString;
}


+ (NSString *)formatDateTime:(NSString *)input
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[input integerValue]];
    
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateTimeString = [dateTimeFormatter stringFromDate:fromDate];
    
    return dateTimeString;
}

+ (NSString *)formatSecondsToMinutes:(int)input
{
    int duration = input;
    int minutes = duration / 60;
    int seconds = duration % 60;
    
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

#pragma mark - Format Balance
+ (NSString *)formatPrice:(NSString *)input
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"EUR"];
    [numberFormatter setMultiplier:[NSNumber numberWithDouble:0.01]];
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[input doubleValue]]];
}

+ (NSString *)formatPlainPrice:(NSString *)input
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@""];
    [numberFormatter setMultiplier:[NSNumber numberWithDouble:0.01]];
    
    NSString *priceString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[input doubleValue]]];
    priceString = [priceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return priceString;
}


#pragma mark - Image URL
+ (NSURL *)imageUrl:(NSURL *)imageUrl forImageView:(UIImageView *)imageView resizeMode:(MGImageResizeMode)resizeMode;
{
    int width = imageView.frame.size.width;
    int height = imageView.frame.size.height;
    
    if([MGUtils isRetina])
    {
        width = width * 2;
        height = height * 2;
    }
    
    NSString *resize;
    switch (resizeMode)
    {
        case MGImageResizeCrop:
            resize = @"c";
            break;
            
        case MGImageResizeFill:
            resize = @"f";
            break;
            
        default:
            resize = @"c";
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@-w%i-h%i-%@", imageUrl.absoluteString, width, height, resize];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

#pragma mark - JSON
+ (NSString *)createJSONObject:(id)input
{
    NSDictionary *dict;
    if (![input isKindOfClass:[NSDictionary class]]) {
        dict = [self objectToNSDictionary:input];
    }
    else
    {
        dict = input;
    }
    NSString *jsonString = [self dictToJSON:dict];
    
    return jsonString;
}

+ (NSDictionary *)objectToNSDictionary:(id)input
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([input class], &count);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for(int i=0;i<count;++i)
    {
        NSString *key = [NSString stringWithCString:property_getName(properties[i])
                                           encoding:NSUTF8StringEncoding];
        
        id value = [input valueForKey:key];
        
        if([value isKindOfClass:[NSNumber class]])
        {
            objc_property_t property = properties[i];
            char *typeEncoding = NULL;
            typeEncoding = property_copyAttributeValue(property, "T");
            
             // bools in obj-c/c are chars...
            if(typeEncoding[0] == 'c')
            {
                // if setting the true/false vars as bool, they will default again to a 1/0
                // so as a ugly hack we str_replace the string values in the json to the bool values...

                if([[NSString stringWithFormat:@"%@", value] isEqualToString:[NSString stringWithFormat:@"%i", 1]])
                    value = @"true";
                else if([[NSString stringWithFormat:@"%@", value] isEqualToString:[NSString stringWithFormat:@"%i", 0]])
                    value = @"false";
            }
            
            [dict setValue:value forKey:key];
            
            free(typeEncoding);

        }
        
        else if([value isKindOfClass:[NSArray class]])
        {
            NSArray *valueArray = (NSArray *)value;
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < valueArray.count; ++i)
            {
                NSDictionary *object = [self objectToNSDictionary:[valueArray objectAtIndex:i]];
                
                [dataArray addObject:object];
            }
            
            [dict setValue:dataArray forKey:key];
        }
        
        else
        {
            [dict setValue:value forKey:key];
        }
    }
    
    free(properties);

    return dict;
}

+ (NSString *)dictToJSON:(NSDictionary *)dict
{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
    
    return jsonString;
}


#pragma mark - URL Encode
+ (NSString *)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

+ (int)calculateBannerHeigthWithWidth:(int)width
{
    int newWidth;
    
    float aspectWidth = 9;
    float aspectHeight = 5;
    
    float aspectRatio = aspectWidth / aspectHeight;
    
    newWidth = width / aspectRatio;
    
    return newWidth;
}

@end
