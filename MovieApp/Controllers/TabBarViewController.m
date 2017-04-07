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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    [self setupTabbar];
}

-(void)setupTabbar{
}

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
