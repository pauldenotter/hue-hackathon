//
//  IntensiteitViewController.h
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntensiteitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *minButton;
@property (weak, nonatomic) IBOutlet UIButton *maxButton;

- (IBAction)minButton:(id)sender;
- (IBAction)maxButton:(id)sender;


@end
