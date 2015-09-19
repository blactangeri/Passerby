//
//  tabbarViewController.m
//  Passerby
//
//  Created by KING J on 7/18/15.
//  Copyright © 2015 James Dong. All rights reserved.
//

#import "tabbarViewController.h"
#import "PhotoViewController.h"
#import "PhotoViewController2.h"

@implementation tabbarViewController:UITabBarController

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationController *nav = [self.viewControllers objectAtIndex:0];
    CGFloat navigationBarHeight = nav.navigationBar.frame.size.height;
    CGRect r = CGRectMake([[UIScreen mainScreen] bounds].size.width / 4.0, 0, [[UIScreen mainScreen] bounds].size.width / 2.0, navigationBarHeight);
    [self.tabBar setFrame:r];
    [self.tabBar setTintColor:[UIColor grayColor]];
    [self.tabBar setBarTintColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
	
	PhotoViewController *photoVC = [[PhotoViewController alloc] init];
	PhotoViewController2 *photoVC2 = [[PhotoViewController2 alloc] init];
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:photoVC];
	UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:photoVC2];
	
	NSArray *arr = [[NSArray alloc] initWithObjects: nav1, nav2, nil];
	
	[self setViewControllers: arr];
	
    UITabBar *bar = self.tabBar;
    UITabBarItem *item1 = [[bar items] objectAtIndex:0];
    UITabBarItem *item2 = [[bar items] objectAtIndex:1];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width / 2.0, navigationBarHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), NO, 0.0);
    [[UIImage imageNamed:@"todo.png"] drawInRect:CGRectMake(0, 0, 25, 25)];
    UIImage *todo = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), NO, 0.0);
    [[UIImage imageNamed:@"save.png"] drawInRect:CGRectMake(0, 0, 25, 25)];
    UIImage *save = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [item1 setImage:todo];
    [item2 setImage:save];
    
    [item1 setImageInsets:UIEdgeInsetsMake(22, 0, -22, 0)];
    [item2 setImageInsets:UIEdgeInsetsMake(22, 0, -22, 0)];

    [self.tabBar setBackgroundImage:image];
    [self.tabBar setTintColor:[UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]];
    self.tabBar.translucent = NO;
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
