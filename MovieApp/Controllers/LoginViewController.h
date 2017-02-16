//
//  LoginViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailEditor;
@property (weak, nonatomic) IBOutlet UITextField *passwordEditor;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotenDetailsButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@end
