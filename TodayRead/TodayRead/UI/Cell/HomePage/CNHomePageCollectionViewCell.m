//
//  CNHomePageCollectionViewCell.m
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNHomePageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CNHomePageCollectionViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.layer.shadowColor = [UIColor colorWithWhite:0.5 alpha:.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 1;
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - public fun

- (void)setInfo:(GGJson *)json
{
    self.titleLabel.text = [json getStringForKey:@"title"];
    
    if ([[json getJsonForKey:@"images"] count] > 0)
    {
        NSString *temp = [[json getJsonForKey:@"images"] getStringForIndex:0];
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:temp]];
    }
}

@end
