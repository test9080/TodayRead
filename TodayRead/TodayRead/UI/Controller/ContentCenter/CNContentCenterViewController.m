//
//  CNContentCenterViewController.m
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNContentCenterViewController.h"
#import "CNUserManager.h"
#import "CNContentCenterTableViewCell.h"

@interface CNContentCenterViewController ()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *introArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

@implementation CNContentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentTableView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.77].CGColor;
    self.contentTableView.layer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    
    //
    [self updateUseCountInfo];
    
    //
    self.titleArray = @[@"之乎者也", @"人微言轻"];
    self.iconArray = @[@"zhihu", @"weixin"];
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

- (void)updateUseCountInfo
{
    // count
    NSString *tempString = [NSString stringWithFormat:@"这是您第%lu次使用谧读", (unsigned long)[[CNUserManager sharedInstance] useCount]];
    
    self.useCountLabel.text = tempString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CNContentCenterTableViewCell";
    
    CNContentCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.iconImageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
