//
//  AppDelegate.m
//  1129vday
//
//  Created by lololol on 26/Oct/14.
//  Copyright (c) 2014 appy.tw. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarController.h"
#import "MSViewController.h"
#import "BLOGTableViewController.h"
#import "FREEViewController.h"
#import "SUPViewController.h"
#import "MAPViewController.h"

#import "PLISTHeader.h"

@interface AppDelegate ()
{
    TabBarController *tabBarController;
    MSViewController *msViewController;
    //簡介，uiview
    BLOGTableViewController *blogTableViewController;
    //戰況，魔王，uitableview
    FREEViewController *freeViewController;
    //佔領，各投開票所資料，uitableview
    SUPViewController *supViewController;
    //地圖，各票所分佈(最後弄)
    MAPViewController *mapViewController;
    //其他，uitableview
    UIImage *uiiTabBarBackground;
}

@end

@implementation AppDelegate

- (void)setMyTabBarItem
{
    //set the tab bar title appearance for normal state
//    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]} forState:UIControlStateSelected];
//    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1]} forState:UIControlStateNormal];
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
//    [UITabBar appearance].tintColor = [UIColor whiteColor];
//    [tabBarController.tabBar setBackgroundColor:[UIColor colorWithRed:0.79 green:0.0 blue:0.18 alpha:1.0]];
    
//    uiiTabBarBackground = [UIImage imageNamed:@"tabbar"];
//    [[UITabBar appearance] setBackgroundImage:uiiTabBarBackground];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [tabBarController.tabBar setBackgroundImage:uiiTabBarBackground];
}

- (void)setMyViewController {
    msViewController = [[MSViewController alloc]init];
    msViewController.title = NSLocalizedString(@"罷免日", nil);
    msViewController.tabBarItem.image = [UIImage imageNamed:@"ms"];
    blogTableViewController = [[BLOGTableViewController alloc]init];
    blogTableViewController.title = NSLocalizedString(@"戰況", nil);
    blogTableViewController.tabBarItem.image = [UIImage imageNamed:@"blog"];
    //戰況，魔王，uitableview
    freeViewController = [[FREEViewController alloc]init];
    freeViewController.title = NSLocalizedString(@"示範區", nil);
    freeViewController.tabBarItem.image = [UIImage imageNamed:@"free"];
    //佔領，各投開票所資料，uitableview
    supViewController = [[SUPViewController alloc]init];
    supViewController.title = NSLocalizedString(@"攻占", nil);
    supViewController.tabBarItem.image = [UIImage imageNamed:@"sup"];
    //地圖，各票所分佈(最後弄)
    mapViewController = [[MAPViewController alloc]init];
    mapViewController.title = NSLocalizedString(@"據點", nil);
    mapViewController.tabBarItem.image = [UIImage imageNamed:@"map"];
    //其他，uitableview

    NSArray *nsaViewControllers = [[NSArray alloc]initWithObjects:msViewController, blogTableViewController, freeViewController, supViewController, mapViewController, nil];
    tabBarController = [[TabBarController alloc]init];
    [tabBarController setViewControllers:nsaViewControllers];    
    [self.window addSubview:tabBarController.view];
}

- (void)downloadFile{
    NSURL *url;
    if (_nssRSSURL == nil || [_nssRSSURL isEqual:@""] == YES) {
        url = [NSURL URLWithString:@"http://appytw.tumblr.com/rss"];
        NSLog(@"Got from url");
    } else {
        url = [NSURL URLWithString:_nssRSSURL];
        NSLog(@"Read from plist");
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            _nssRSSContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self writeToMyPlist];
            NSLog(@"Content: %@", _nssRSSContent);
        } else {
            NSLog(@"Download url error: %@", connectionError);
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self readAllFromMyPlist];
    [self downloadFile];
    [self setMyViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setNotification:application];
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "tw.1129vday._129vday" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"_129vday" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"_129vday.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)setNotification:(UIApplication *)application
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.nssDeviceToken = [[[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"receive deviceToken: %@", self.nssDeviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Remote notification error:%@", [error localizedDescription]);
}

//[[Plist

- (void)initMyPlist
{
    NSFileManager *nsfmPlistFileManager = [[NSFileManager alloc]init];
    NSString *nssPlistSrc = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"plist"];
    _nssPlistDst = [NSString stringWithFormat:@"%@/Documents/UserData.plist", NSHomeDirectory()];
    if (! [nsfmPlistFileManager fileExistsAtPath:_nssPlistDst]) {
        [nsfmPlistFileManager copyItemAtPath:nssPlistSrc toPath:_nssPlistDst error:nil];
    }
}

- (void)writeToMyPlist
{
    if (_nssPlistDst == nil) {
        [self initMyPlist];
    }
    NSMutableDictionary *nsmdPlistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_nssPlistDst];
    [nsmdPlistDictionary setValue:_nssUserName forKey:PLIST_USER_NAME];
    [nsmdPlistDictionary setValue:_nssDeviceToken forKey:PLIST_USER_DEVICE_TOKEN];
    [nsmdPlistDictionary setValue:_nssGesturePassword forKey:PLIST_USER_GESTURE_PASSWORD];
    [nsmdPlistDictionary setValue:_nssPassword forKey:PLIST_USER_PASSWORD];
    [nsmdPlistDictionary setValue:_nssPhone forKey:PLIST_USER_PHONE];
    [nsmdPlistDictionary setValue:_nssRSSContent forKey:PLIST_RSS_CONTENT];
    [nsmdPlistDictionary setValue:_nssRSSURL forKey:PLIST_RSS_URL];
    [nsmdPlistDictionary setValue:_nssTsaiWuLin forKey:PLIST_TSAI_WU_LIN];
    [nsmdPlistDictionary setValue:_nssAddress forKey:PLIST_ADDRESS];
    [nsmdPlistDictionary setValue:_nssGPSX forKey:PLIST_GPSX];
    [nsmdPlistDictionary setValue:_nssGPSY forKey:PLIST_GPSY];
    [nsmdPlistDictionary writeToFile:_nssPlistDst atomically:YES];
}

- (void)readAllFromMyPlist {
    if (_nssPlistDst == nil) {
        [self initMyPlist];
    }
    NSMutableDictionary *nsmdPlistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_nssPlistDst];
    if (nsmdPlistDictionary != nil) {
        _nssUserName = [nsmdPlistDictionary objectForKey:PLIST_USER_NAME];
        _nssDeviceToken = [nsmdPlistDictionary objectForKey:PLIST_USER_DEVICE_TOKEN];
        _nssGesturePassword = [nsmdPlistDictionary objectForKey:PLIST_USER_GESTURE_PASSWORD];
        _nssPassword = [nsmdPlistDictionary objectForKey:PLIST_USER_PASSWORD];
        _nssPhone = [nsmdPlistDictionary objectForKey:PLIST_USER_PHONE];
        _nssRSSContent = [nsmdPlistDictionary objectForKey:PLIST_RSS_CONTENT];
        _nssRSSURL = [nsmdPlistDictionary objectForKey:PLIST_RSS_URL];
        _nssTsaiWuLin = [nsmdPlistDictionary objectForKey:PLIST_TSAI_WU_LIN];
        _nssAddress = [nsmdPlistDictionary objectForKey:PLIST_ADDRESS];
        _nssGPSX = [nsmdPlistDictionary objectForKey:PLIST_GPSX];
        _nssGPSY = [nsmdPlistDictionary objectForKey:PLIST_GPSY];
    }
}

//]]Plist

@end