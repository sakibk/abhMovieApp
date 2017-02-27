//
//  ForgottenPasswordViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ForgottenPasswordViewController.h"

@interface ForgottenPasswordViewController ()

@end

@implementation ForgottenPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fullURL = @"https://www.themoviedb.org/account/reset-password";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
