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
#import <Realm/Realm.h>
#import "Movie.h"
#import "TVShow.h"
#import "NotificationListViewController.h"
#import "ListMapping.h"
#import "ListMappingTV.h"
#import "ObjectMapper.h"

@interface AppDelegate ()
@property NSMutableArray<Movie*> *notifMovies;
@property NSMutableArray<TVShow*> *notifShows;
@property NSNumber *currentPage;
@property ListMappingTV *lmp;
@end

@implementation AppDelegate

-(void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    NSLog(@"%@",notification);

    if([[notification alertTitle] isEqualToString:@"Upcoming Movies"]){
        [self getMovies];
    }
    else{
        [self getShowLists];
    }
    
}
-(void)getMovies{
    
    NSString *pathP =@"/3/movie/upcoming";
   
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _notifMovies = [[NSMutableArray alloc] initWithArray:mappingResult.array];
        if(_notifMovies.firstObject!=nil){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationListViewController *list = [storyboard instantiateViewControllerWithIdentifier:@"Notifications"];
            [list setNotificationMovies:_notifMovies];
            [list setIsMovie:YES];
            [list initWithNotificationMovie];
            UINavigationController *navigationController =(UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] ;
            [navigationController pushViewController:list animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
    }


-(void)getShowLists{
    NSString *pathP =@"/3/tv/airing_today";
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _lmp=[[mappingResult array] firstObject];
        for(TVShow *tv in [_lmp showList]){
            [_notifShows addObject:tv];
        }
        if([[_lmp pageCount] isEqualToNumber:_currentPage] || [[_lmp pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationListViewController *list = [storyboard instantiateViewControllerWithIdentifier:@"Notifications"];
            [list setNotificationShows:_notifShows];
            [list setIsMovie:NO];
            [list initWithNotificationShow];
            UINavigationController *navigationController =(UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] ;
            [navigationController pushViewController:list animated:YES];
        }
        
        else if([_lmp pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getShowLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}


//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }

    
//    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
//    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
//    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKObjectManager setSharedManager:[self setupRestKit]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    [[UINavigationBar appearance] setContentMode:UIViewContentModeCenter];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    
    [self setupSidebar];
    [self requestAuthorisation];
    [self setNotifications];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 3;
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Realm will automatically detect new properties and removed properties
        }
    };
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    
    return YES;
}


// Move this method in AppDelegate and call in didFinishLaunchingWithOptions.
-(RKObjectManager *)setupRestKit {
    [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Here you need to set base url of your API
    AFRKHTTPClient *client = [AFRKHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://api.themoviedb.org"]];
    
    // Set needed headers.
    [client setDefaultHeader:@"content-type" value:@"application/json;charset=utf-8"];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Call mapping method.
    [ObjectMapper setObjectManagerMapping];
    
    return objectManager;
}


-(void)requestAuthorisation{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];

}

-(void)setNotifications{
    NSDictionary *userCredits=[[NSDictionary alloc]init];
    BOOL isLoged = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(isLoged){
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
        
        if([[userCredits objectForKey:@"movieNotification"] boolValue]){
            [self setupNotification];
            NSLog(@"notification Set");
        }
        
        
        
        if([[userCredits objectForKey:@"showNotification"] boolValue]){
            [self setupShowNotification];
            NSLog(@"notification Set");
        }
        
        
        
    }
}
-(void)setupShowNotification{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    [nowComponents setHour:12];
    [nowComponents setMinute:50];
    [nowComponents setSecond:00];
    [nowComponents setWeekday:1];
    
    NSLog(@"%@",nowComponents);
    
    NSDate * notificationDate = [gregorian dateFromComponents:nowComponents];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = notificationDate;
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.alertBody = @"Your Episodes are on TV Today";
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.alertTitle = @"Airing Today";
    localNotification.alertAction = @"Details";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.category = @"reminderCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)setupNotification{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    [nowComponents setHour:17];
    [nowComponents setMinute:30];
    [nowComponents setSecond:00];
    [nowComponents setWeekday:5];
    
    NSLog(@"%@",nowComponents);
    
    NSDate * notificationDate = [gregorian dateFromComponents:nowComponents];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = notificationDate;
    localNotification.repeatInterval = NSCalendarUnitWeekOfYear;
    localNotification.alertBody = @"Come out and check out upcoming movies";
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.alertTitle = @"Upcoming Movies";
    localNotification.alertAction = @"Details";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.category = @"reminderCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)getNotificationSettingsWithCompletionHandler:(void (^)(UNNotificationSettings *settings))completionHandler{
    
}

- (void)getDeliveredNotificationsWithCompletionHandler:(void (^)(NSArray<UNNotification *> *notifications))completionHandler{
    
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}

- (void)removeDeliveredNotificationsWithIdentifiers:(NSArray<NSString *> *)identifiers{
    
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
