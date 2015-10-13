//
//  AppDelegate.m
//  TodayRead
//
//  Created by cn on 15/10/12.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "AppDelegate.h"
#import "CNWelcomeViewController.h"
#import "CNUserManager.h"
#import "JASidePanelController.h"
#import "CNHomeViewController.h"
#import "CNContentCenterViewController.h"
#import "CNUserCenterViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIWindow *welcomeWindow;
@property (strong, nonatomic) CNWelcomeViewController *welcomeViewController;

@property (strong, nonatomic) JASidePanelController *sidePanelController;
@property (strong, nonatomic) CNHomeViewController *homeViewController;
@property (strong, nonatomic) CNContentCenterViewController *contentCenterViewController;
@property (strong, nonatomic) CNUserCenterViewController *userCenterViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // user manager
    [[CNUserManager sharedInstance] addUseCount];
    
    // init ui
    [self configUIFramework];
    
    // show welcome
    [self showWelcomeView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - welcome

- (void)showWelcomeView
{
    self.welcomeWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.welcomeWindow.windowLevel = UIWindowLevelNormal + 1;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.welcomeViewController = [board instantiateViewControllerWithIdentifier:@"CNWelcomeViewController"];
    
    self.welcomeWindow.rootViewController = self.welcomeViewController;
    self.welcomeWindow.hidden = NO;
    
    [UIView animateKeyframesWithDuration:.7
                                   delay:.9
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  self.welcomeWindow.alpha = 0;
                              } completion:^(BOOL finished) {
                                  self.welcomeWindow = nil;
                                  self.welcomeViewController = nil;
                              }];
}

#pragma mark - ui framework

- (void)configUIFramework
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.sidePanelController = [[JASidePanelController alloc] init];
    self.sidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // left
    self.contentCenterViewController = [board instantiateViewControllerWithIdentifier:@"CNContentCenterViewController"];
    self.sidePanelController.leftPanel = self.contentCenterViewController;
    
    // center
    self.homeViewController = [board instantiateViewControllerWithIdentifier:@"CNHomeViewController"];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    
    // right
    self.userCenterViewController = [board instantiateViewControllerWithIdentifier:@"CNUserCenterViewController"];
    self.sidePanelController.rightPanel = self.userCenterViewController;
    
    self.window.rootViewController = self.sidePanelController;
    [self.window makeKeyAndVisible];
}

@end
