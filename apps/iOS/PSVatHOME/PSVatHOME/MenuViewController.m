//
//  MenuViewController.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"

#import "IntensiteitViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

UIImageView *navBarHairlineImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:28.f/255.f green:27.f/255.f blue:27.f/255.f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    if(indexPath.row == 5)
        CellIdentifier = @"MenuItemLogo";
    else
        CellIdentifier = @"MenuItem";
        
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    
    if(indexPath.row == 0)
    {
        MenuItemCell *c = (MenuItemCell *)cell;
        [c.icon setImage:[UIImage imageNamed:@"bridge_icon"]];
        [c.title setText:@"Koppel Hue"];
    }
    if(indexPath.row == 1)
    {
        MenuItemCell *c = (MenuItemCell *)cell;
        [c.icon setImage:[UIImage imageNamed:@"huelines_icon"]];
        [c.title setText:@"Licht intensiteit"];
    }
    if(indexPath.row == 2)
    {
        MenuItemCell *c = (MenuItemCell *)cell;
        [c.icon setImage:[UIImage imageNamed:@"notifications_icon"]];
        [c.title setText:@"Notificaties"];
    }
    if(indexPath.row == 3)
    {
        MenuItemCell *c = (MenuItemCell *)cell;
        [c.icon setImage:[UIImage imageNamed:@"share_icon"]];
        [c.title setText:@"Delen"];
    }
    if(indexPath.row == 4)
    {
        MenuItemCell *c = (MenuItemCell *)cell;
        [c.icon setImage:[UIImage imageNamed:@"apps_icon"]];
        [c.title setText:@"Meer apps"];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ConnectHueViewController"]
                                             animated:YES];
    }
    
    if(indexPath.row == 1)
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"IntensiteitViewController"]
                                             animated:YES];
    }
    
    if(indexPath.row == 2)
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"]
                                             animated:YES];
    }
    
    if(indexPath.row == 3)
    {
        NSString *textToShare = @"Steun ook PSV thuis met de PSV at HOME hue app, want eendracht maakt macht. #philipshue";
        NSArray *itemsToShare = @[textToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
    if(indexPath.row == 4)
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"]
                                             animated:YES];
    }
}

- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

@end
