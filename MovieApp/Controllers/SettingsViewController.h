//
//  SettingsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountUsername;
@property (weak, nonatomic) IBOutlet UISwitch *movieNotification;
@property (weak, nonatomic) IBOutlet UISwitch *showNotification;


@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieNotificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *showNotificationLabel;

@end
