//
//  MenuItemCell.m
//  PSVatHOME
//
//  Created by Glenn Tillemans on 01-02-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "MenuItemCell.h"
#import "FontHelper.h"

@implementation MenuItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self.title setFont:[FontHelper regularFontOfSize:18]];
}

@end
