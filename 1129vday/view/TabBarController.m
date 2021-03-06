//
//  TabBarController.m
//  1129vday
//
//  Created by lololol on 26/Oct/14.
//  Copyright (c) 2014 appy.tw. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)setMyFrame
{
    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 88);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    //    [v setBackgroundColor:[UIColor redColor]];
    //        [v setAlpha:0.5];
    self.tabBar.layer.borderWidth = 0.5;
    self.tabBar.layer.borderColor = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor];

    [[self tabBar] addSubview:v];
}

- (void)setMyTabBarItem
{
    //set the tab bar title appearance for normal state
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.13 blue:0.25 alpha:1.0]} forState:UIControlStateSelected];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]} forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [UITabBar appearance].tintColor = [UIColor redColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyFrame];
    [self setMyTabBarItem];

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

@end
