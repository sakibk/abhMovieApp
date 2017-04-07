//
//  SuccessfulPaymentViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 06/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SuccessfulPaymentViewController.h"

@interface SuccessfulPaymentViewController ()

@end

@implementation SuccessfulPaymentViewController
{
    UIView *bottomView;
    UIButton *bottomButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle];
    [self createBackToCinemaButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=@"Congratulations";
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)createBackToCinemaButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"BACK TO CINEMA" forState:UIControlStateNormal];
    [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3.0f;
    [bottomButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    [self.view addSubview:bottomView];
    
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
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
