//
//  ViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) NSDate *date;;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.progress setBackBorderWidth: 1.0];
    [self.progress setFrontBorderWidth: 5.0];
    [self.progress setColorTable: @{
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):[UIColor whiteColor],
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):[UIColor whiteColor]
                                  }];
    
    [self.progress setText:@""];
    [self.progress setProgress:0];
    
    [self setBackgroundColorHue:4 saturation:78 brightness:89];
    
    [self.countLabel setFont:[FontHelper regularFontOfSize:42]];
    [self.countLabel setText:@"0"];
    
    self.socketController = [[SocketController alloc] init];
    [self.socketController setDelegate:self];
    [self.socketController open];
    
    [self.progress drawLineAtAngle:32 inRect:self.progress.frame];
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


#pragma mark IBActions
- (IBAction)menuButton:(id)sender
{
//    [self.slidePanel anchorTopPanelTo:MGSideRight];
    
}


#pragma mark SocketControllerDelegate

- (void)message:(NSString *)message
{
    [self handleData:message];
    
}

- (void)handleData:(NSString *)data
{
    NSError *jsonError;
    NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    
    if([[json objectForKey:@"type"] isEqualToString:@"start"])
    {
        
        [self updateTime:[json objectForKey:@"ts"]];
    }
    
    if([[json objectForKey:@"type"] isEqualToString:@"userCount"])
    {
        [self.countLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"count"]]];
    }
    
    if([[json objectForKey:@"type"] isEqualToString:@"light"])
    {
        NSDictionary *body = [json objectForKey:@"body"];
        [self setBackgroundColorHue:[[body objectForKey:@"hue"] floatValue]
                         saturation:[[body objectForKey:@"sat"] floatValue]
                         brightness:[[body objectForKey:@"bri"] floatValue]];

    }
    
    [self updateTime:[json objectForKey:@"ts"]];
}

-(void)updateTime:(NSString *)dateString
{
//    [self.progress setProgress:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *formattedDate = [dateFormat dateFromString:dateString];
    
    
    
    if(self.date != nil)
    {
        NSTimeInterval secondsBetween = [formattedDate timeIntervalSinceDate:self.date];
        
        
        NSLog(@"between: %f", secondsBetween);
        
        float percentage = secondsBetween * 100 / (90 * 60);
        
        [self.progress setProgress:self.progress.progress + percentage/10];
        NSLog(@"progress: %f", self.progress.progress);
    }
    
    self.date = formattedDate;
}

@end
