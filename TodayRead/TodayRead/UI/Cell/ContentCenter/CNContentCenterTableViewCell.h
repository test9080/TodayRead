//
//  CNContentCenterTableViewCell.h
//  TodayRead
//
//  Created by cn on 15/10/14.
//  Copyright © 2015年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNContentCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setInfo;

@end
