//
//  ViewController.h
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"

#import "FontHelper.h"
#import "BackgroundGradient.h"
#import "SocketController.h"



@interface RootViewController : UIViewController <SocketControllerDelegate>

@property (weak, nonatomic) IBOutlet KAProgressLabel *progress;
- (IBAction)slider:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) SocketController *socketController;


@end

