//
//  TabBarViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 31/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSLog(@"controller title: %@", viewController.title);
    
    if (viewController == tabBarController)
    {
        tabBarController.delegate = self;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController == self.tabBarController.navigationController)
    {
        NSLog(@"more controller class: %@", NSStringFromClass([viewController class]));
        NSLog(@"more controller title: %@", viewController.title);
    }
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
