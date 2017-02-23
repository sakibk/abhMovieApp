//
//  SettingsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property NSDictionary *userCredits;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
//    .contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    _accountName.text=[_userCredits valueForKey:@"name"];
    _accountUsername.text=[_userCredits valueForKey:@"username"];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
    _movieNotification.layer.cornerRadius = 16.0;
    _showNotification.layer.cornerRadius = 16.0;
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
