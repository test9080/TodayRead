//
//  CNHomePageCollectionViewCell.h
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGJson.h"

@interface CNHomePageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setInfo:(GGJson *)json;

@end
