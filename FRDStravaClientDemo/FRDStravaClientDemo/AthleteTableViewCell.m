//
//  AthleteTableViewCell.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteTableViewCell.h"

@implementation AthleteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
