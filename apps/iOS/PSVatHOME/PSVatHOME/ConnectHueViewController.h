//
//  ConnectHueViewController.h
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"

@interface ConnectHueViewController : UIViewController

@property (weak, nonatomic) IBOutlet KAProgressLabel *progress;
- (IBAction)connectButton:(id)sender;

@end
