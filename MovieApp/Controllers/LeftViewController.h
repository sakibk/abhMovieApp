//
//  LeftViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LGSideMenuController/LGSideMenuController.h>

@interface LeftViewController : UITableViewController<LGSideMenuControllerDelegate>

@property (strong,nonatomic)UIButton *menuButton;

@end
