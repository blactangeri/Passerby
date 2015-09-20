#import "AppDelegate.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "ListEntries.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];

    //UIImage *backButtonImage = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //[Parse setApplicationId:@"ODa3WmLq7fkFrSVDHu9jU3qaYvMAsTjVqYQgHllI" clientKey:@"zGKQnGxOh5cW0Rf3OTbY3VXC0zwdVWURgCWmGkwe"];
	
	
	if ([[ListEntries sharedEntries] allEntries].count == 0) {
		[application setApplicationIconBadgeNumber:0];
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}
	
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        ViewController *viewController = [[ViewController alloc] init];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
	}
	
	/*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                                                 UIUserNotificationTypeBadge |
                                                                                 UIUserNotificationTypeSound
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
    }
    */
	
	UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
	UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
	
	[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
	
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
    }
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[ListEntries sharedEntries] saveChanges];
    
    if (success) {
        //NSLog(@"data saved");
    }
    //else NSLog(@"data not saved");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    BOOL success = [[ListEntries sharedEntries] saveChanges];
    
    if (success) {
        //NSLog(@"data saved");
    }
    //else NSLog(@"data not saved");
}

- (BOOL)application:(nonnull UIApplication *)application shouldRestoreApplicationState:(nonnull NSCoder *)coder
{
    return YES;
}

/*
- (void)application:(nonnull UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(nonnull UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(nonnull UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}
*/

- (void)application:(nonnull UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    /*UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passerby"
                                                        message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    */
    application.applicationIconBadgeNumber = 0;
}


@end
