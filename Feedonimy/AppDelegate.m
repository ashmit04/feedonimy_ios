//
//  AppDelegate.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //make sure that the FBLoginView class is loaded before the view is shown
    [FBLoginView class];
    // Create a LoginUIViewController instance where the login button will be
//    LoginViewController *loginUIViewController = [[LoginViewController alloc] init];
//    // Set loginUIViewController as root view controller
//    [[self window] setRootViewController:loginUIViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navback-red.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    //animate launc
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
 //   self.viewController = [[MyFeedsViewController alloc]init];//[[UIViewController alloc] initWithNibName:@"" bundle:nil];
  //  self.window.rootViewController = self.viewController;
 //   [self.window makeKeyAndVisible];
    
    
    //add the image to the forefront...
    UIImageView *splashImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [splashImage setImage: [UIImage imageNamed:@"Default@2x"]];
    [self.window addSubview:splashImage];
    [self.window bringSubviewToFront:splashImage];
    
    
    //set an anchor point on the image view so it opens from the left
    splashImage.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //reset the image view frame
    splashImage.frame = [UIScreen mainScreen].bounds;
    
    //animate the open
    [UIView animateWithDuration:1.5
                          delay:0.6
                        options:(UIViewAnimationCurveEaseOut)
                     animations:^{
                         
                         splashImage.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
                     } completion:^(BOOL finished){
                         
                         //remove that imageview from the view
                         [splashImage removeFromSuperview];
                     }];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation{
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
     // You can add your app-specific url handling code here if needed
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return wasHandled;
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
}

@end
