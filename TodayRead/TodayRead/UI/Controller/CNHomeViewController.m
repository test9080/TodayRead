//
//  CNRootViewController.m
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNHomeViewController.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "CNHomePageCollectionViewCell.h"

@interface CNHomeViewController ()

@end

@implementation CNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - public fun

#pragma mark - private fun

#pragma mark - ui helper

- (void)configNavigationBar
{
    // title
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_logo_str"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 200, 44);
    imageView.clipsToBounds = YES;
    self.navigationItem.titleView = imageView;
    
    // left
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:@"content_center_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showContentCenter) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // right
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:@"user_center_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showUserCenter) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)showContentCenter
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)showUserCenter
{
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNHomePageCollectionViewCell *cell = (CNHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CNHomePageCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor colorWithRed:(CGFloat)(rand() % 255) / 255.0
                                           green:(CGFloat)(rand() % 255) / 255.0
                                            blue:(CGFloat)(rand() % 255) / 255.0
                                           alpha:1.0];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self.class divideFromTheMiddle:collectionView.frame.size.width - 20 divisor:2 receiveRedundancy:(indexPath.row + 1) % 2 == 0],
                      [self.class divideFromTheMiddle:self.view.frame.size.height - 64 divisor:2.5 receiveRedundancy:NO]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
    return CGSizeMake(collectionView.bounds.size.width, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
    return CGSizeMake(collectionView.bounds.size.width, 80);
}

#pragma mark - ui helper

+ (NSUInteger)divideFromTheMiddle:(NSUInteger)containerLength divisor:(NSUInteger)divisor receiveRedundancy:(BOOL)receiveRedundancy
{
    CGFloat temp = (CGFloat)containerLength / divisor;
    
    if (receiveRedundancy)
    {
        temp += containerLength - (NSUInteger)temp * divisor;
    }
    
    return (NSUInteger)temp;
}

@end
