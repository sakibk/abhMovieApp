//
//  TabBarViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 31/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TabBarViewController.h"
#import "MoviesViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LeftViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController
{
    LGSideMenuController *sideMenuController;
    UITableViewController *leftViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
//    [self setupSidebar];
}
//
//-(void)setupSidebar{
//    leftViewController = [LeftViewController new];
////    rightViewController= [UITableViewController new];
//    
//    
//    sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:self
//                                                                     leftViewController:leftViewController
//                                                                    rightViewController:nil];
//    
//    
//    
//    sideMenuController.leftViewController=leftViewController;
//    sideMenuController.leftViewWidth = 250.0;
//    sideMenuController.rootViewCoverColorForLeftView = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.00];
//    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
//    
//    sideMenuController.rightViewWidth = 0.0;
//    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
//    UIWindow *window = UIApplication.sharedApplication.delegate.window;
//    window.rootViewController = sideMenuController;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 1:
        {
            MoviesViewController *moviesVC = (MoviesViewController *)[[(UINavigationController *)viewController viewControllers] objectAtIndex:0];
            moviesVC.isMovie = YES;
        }
            break;
        case 2:
        {
            MoviesViewController *moviesVC = (MoviesViewController *)[[(UINavigationController *)viewController viewControllers] objectAtIndex:0];
            moviesVC.isMovie = NO;
        }
        default:
            break;
    }
}


@end
