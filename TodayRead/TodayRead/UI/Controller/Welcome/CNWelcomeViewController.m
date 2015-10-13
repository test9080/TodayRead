//
//  CNWelcomeViewController.m
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNWelcomeViewController.h"
#import "UIColor+GGColor.h"
#import "CNUserManager.h"

@interface CNWelcomeViewController ()

@end

@implementation CNWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showWelcomeString];
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

#pragma mark - show welcom string

- (void)showWelcomeString
{
    NSMutableString *showString = [[NSMutableString alloc] initWithCapacity:20];
    
    // date
    NSDate *date = [NSDate date];
    NSString *tempString = [NSDateFormatter localizedStringFromDate:date
                                                                    dateStyle:(NSDateFormatterStyle)NSDateIntervalFormatterMediumStyle
                                                                    timeStyle:NSDateFormatterNoStyle];
    [showString appendFormat:@"小主，今天是%@\n\n", tempString];
    
    // count
    tempString = [NSString stringWithFormat:@"这是您第%lu次打开谧读", (unsigned long)[[CNUserManager sharedInstance] useCount]];
    [showString appendString:tempString];
    
    self.welcomeLabel.text = showString;
    
    self.welcomeLabel.alpha = 0;
    [UIView animateWithDuration:.5
                     animations:^{
                         self.welcomeLabel.alpha = 1;
                     }];
}

@end
