//
//  MoreViewController.h
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
- (IBAction)psvButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *psvLabel;

- (IBAction)hueButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hueLabel;

- (IBAction)abmilightButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ambilightLabel;


@end
