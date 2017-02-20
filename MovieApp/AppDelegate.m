//
//  AppDelegate.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "RKObjectManager+SharedInstances.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LeftViewController.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [Fabric with:@[[Crashlytics class]]];
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKObjectManager setSharedManager:manager];
    
//    NSURL *baseURLBoxOffice = [NSURL URLWithString:@"http://www.boxofficemojo.com"];
//    AFRKHTTPClient *clientBoxOffice = [[AFRKHTTPClient alloc] initWithBaseURL:baseURLBoxOffice];
//    [[RKObjectManager boxOfficeManager] setHTTPClient:clientBoxOffice];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    [self setupSidebar];
    
    return YES;
}


-(void)setupSidebar{
    LeftViewController *leftViewController = [LeftViewController new];
    //    rightViewController= [UITableViewController new];
    
    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
                                                                     leftViewController:leftViewController
                                                                    rightViewController:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sideMenuController];

    
//    sideMenuController.leftViewController=leftViewController;
    sideMenuController.leftViewWidth = [[[[[UIApplication sharedApplication] delegate] window] rootViewController].view bounds].size.width/4+[[[[[UIApplication sharedApplication] delegate] window] rootViewController].view bounds].size.width/64;
    sideMenuController.leftViewBackgroundColor=[UIColor clearColor];
    sideMenuController.rootViewCoverColorForLeftView = [UIColor blackColor];
    sideMenuController.rootViewCoverAlphaForLeftView=0.3;
    sideMenuController.rootViewCoverBlurEffectForLeftView =[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    sideMenuController.rightViewWidth = 0.0;
    [sideMenuController.navigationController.navigationBar setHidden:YES];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
