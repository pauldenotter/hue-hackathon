//
//  ViewController.h
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioController.h"
#import "AudioControllerDelegate.h"
#import "SocketController.h"


@interface RootViewController : UIViewController <AudioControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)clickButton:(id)sender;


@property (nonatomic, strong) AudioController *audioController;
@property (nonatomic, strong) SocketController *socketController;

@end

