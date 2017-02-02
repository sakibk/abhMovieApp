//
//  TabBarViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 31/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;

@end
