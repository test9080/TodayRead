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
#import "GGTask.h"
#import "GGEngine.h"
#import "GGJson.h"
#import "GGDataManager.h"

@interface CNHomeViewController () <GGDataObserver>

@end

@implementation CNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBar];
    
    [self requestListData];
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
    return [[[self getListData] getJsonForKey:@"stories"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNHomePageCollectionViewCell *cell = (CNHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CNHomePageCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    GGJson *json = [[[self getListData] getJsonForKey:@"stories"] getJsonForIndex:(int)indexPath.row];
    [cell setInfo:json];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self.class divideFromTheMiddle:collectionView.frame.size.width - 36 divisor:2 receiveRedundancy:(indexPath.row + 1) % 2 == 0];
    return CGSizeMake(width,
                      width / 0.618);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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

#pragma mark - net help

// 发起网络请求
- (void)requestListData
{
    //    NSString *listType = @"电视剧";
    
    // 创建Task，task关联data，请求类型（刷新还是查看更多），指定dataId（dataID可以用于区分url相同，但参数不同的url请求）
    GGTask *task = [GGTask createWithSender:self
                            forDataCategory:@"ZhihuListData"
                             forRequestType:GGDATA_REQUEST_REFRESH
                                  forDataID:0];
    //    task.argDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:listType, @"category", nil];
    
    // 将task加入引擎，由引擎实现网络传输，后续的json解析等
    [[GGEngine sharedInstance] addTask:task];
    
    // 添加观察者
    [[GGEngine sharedInstance] addDataObserver:self forDataCategory:@"ZhihuListData"];
}

// 取出data数据
- (GGJson *)getListData
{
    GGJson *json = [[[GGDataManager sharedInstance] getGGDataForCategory:@"ZhihuListData"] getGGJsonObjectForID:0];
    return json;
}

// 处理网络请求回调
#pragma mark - GGDataObserver

- (void)requestSuccessForTask:(GGTask *)task // 成功回调
{
    if ([@"ZhihuListData" isEqualToString:task.dataCategory]) // 判断是哪个data发起的请求
    {
        [self.articleCollectionView reloadData];
        //        GGJson *json = [self getListData];
        //        int a = 0;
    }
}

- (void)requestFailedForTask:(GGTask *)task withError:(NSError*) error // 失败回调
{
    if ([@"ZhihuListData" isEqualToString:task.dataCategory])
    {
        //        GGJson *json = [self getListData];
        //        int a = 0;
    }
}

@end
