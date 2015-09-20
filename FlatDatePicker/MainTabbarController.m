
#import "MainTabbarController.h"


@implementation MainTabbarController:UITabBarController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//UINavigationController *nav = [self.viewControllers objectAtIndex:0];
	//CGFloat navigationBarHeight = nav.navigationBar.frame.size.height;
	//CGRect r = CGRectMake([[UIScreen mainScreen] bounds].size.width / 4.0, 0, [[UIScreen mainScreen] bounds].size.width / 2.0, navigationBarHeight);
	//[self.tabBar setFrame:r];
	
	[self.tabBar setTintColor:[UIColor blackColor]];
	[self.tabBar setBarTintColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
	[self.tabBar setBarTintColor:[UIColor whiteColor]];
	//[self.tabBar setBackgroundImage:image];
	[self.tabBar setTintColor:[UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]];
	self.tabBar.translucent = YES;

	
	UITabBar *bar = self.tabBar;
	UITabBarItem *item1 = [[bar items] objectAtIndex:0];
	UITabBarItem *item2 = [[bar items] objectAtIndex:1];
	UITabBarItem *item3 = [[bar items] objectAtIndex:2];
	
	/*CGRect rect = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width / 2.0, navigationBarHeight);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0] CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	 */
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(26, 26), NO, 0.0);
	[[UIImage imageNamed:@"user2.png"] drawInRect:CGRectMake(0, 0, 26, 26)];
	UIImage *img1 = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(26, 26), NO, 0.0);
	[[UIImage imageNamed:@"listfilled.png"] drawInRect:CGRectMake(0, 0, 26, 26)];
	UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(26, 26), NO, 0.0);
	[[UIImage imageNamed:@"cal.png"] drawInRect:CGRectMake(0, 0, 26, 26)];
	UIImage *img3 = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[item1 setImage:img1];
	[item2 setImage:img2];
	[item3 setImage:img3];
	
	[item1 setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[item2 setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[item3 setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	
}

@end
