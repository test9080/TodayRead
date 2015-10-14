//
//  CNContentCenterTableViewCell.m
//  TodayRead
//
//  Created by cn on 15/10/14.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNContentCenterTableViewCell.h"

@implementation CNContentCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public fun

- (void)setInfo
{

}

#pragma mark - private fun

@end
