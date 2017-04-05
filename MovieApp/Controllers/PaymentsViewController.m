//
//  PaymentsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 05/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PaymentsViewController.h"
#import  <QuartzCore/QuartzCore.h>

@import Firebase;
@import Stripe;

@interface PaymentsViewController ()

@end

@implementation PaymentsViewController
{
    UIView *bottomView;
    UIView *topButtonsView;
    UIView *textFieldsView;
    UITextField *nameField;
    UITextField *cardNumberField;
    UITextField *expirationField;
    UITextField *securityCodeField;
    UIButton *bottomButton;
    UIButton *visa;
    UIButton *master;
    BOOL isVisa;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createButtonsView];
    [self createTextfieldViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createButtonsView{
    CGRect viewRect = CGRectMake(0, 60, self.view.bounds.size.width, 85);
    topButtonsView = [[UIView alloc] initWithFrame:viewRect];
    [topButtonsView setBackgroundColor:[UIColor clearColor]];
    CGFloat buttonWidth = (self.view.bounds.size.width-60)/2;
    CGFloat buttonHeight = 45;
    CGRect visaButtonRect = CGRectMake(20, 25, buttonWidth, buttonHeight);
    visa = [[UIButton alloc] initWithFrame:visaButtonRect];
    [visa setBackgroundColor:[UIColor darkGrayColor]];
    [visa setTitle:@"Visa" forState:UIControlStateNormal];
    [visa setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[visa layer] setBorderWidth:1.0f];
    [[visa layer] setCornerRadius:4.0f];
    [[visa layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [visa addTarget:self action:@selector(pickVisaOrMaster:) forControlEvents:UIControlEventTouchUpInside];
    [visa setTag:1];
    
    [topButtonsView addSubview:visa];
    
    CGRect masterButtonRect = CGRectMake(buttonWidth+40, 25, buttonWidth, buttonHeight);
    master=[[UIButton alloc]initWithFrame:masterButtonRect];
    [master setBackgroundColor:[UIColor darkGrayColor]];
    [master setTitle:@"Mastercard" forState:UIControlStateNormal];
    [master setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[master layer] setBorderWidth:1.0f];
    [[master layer] setCornerRadius:4.0f];
    [[master layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [master addTarget:self action:@selector(pickVisaOrMaster:) forControlEvents:UIControlEventTouchUpInside];
    [master setTag:2];
    
    [topButtonsView addSubview:master];
    
    [self.view addSubview:topButtonsView];
}

-(IBAction)pickVisaOrMaster:(id)sender{
    if([sender tag]==1){
        isVisa=YES;
        [visa setTitleColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [visa setBackgroundColor:[UIColor blackColor]];
        [[visa layer] setBorderColor:[[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] CGColor]];
        [master setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [master setBackgroundColor:[UIColor darkGrayColor]];
        [[master layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    }else{
        isVisa=NO;
        [master setTitleColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [master setBackgroundColor:[UIColor blackColor]];
        [[master layer] setBorderColor:[[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] CGColor]];
        [visa setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [visa setBackgroundColor:[UIColor darkGrayColor]];
        [[visa layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    }
}

-(void)createTextfieldViews{
    CGRect textfieldViewRect= CGRectMake(0, 145, self.view.bounds.size.width, self.view.bounds.size.width/4);
    textFieldsView=[[UIView alloc]initWithFrame:textfieldViewRect];
    CGFloat textHeight = textfieldViewRect.size.height/4;
    CGFloat textWidth =textfieldViewRect.size.width-40;
    CGRect nameRect = CGRectMake(20, 0, textWidth, textHeight);
    nameField = [[UITextField alloc]initWithFrame:nameRect];
    [nameField setBorderStyle:UITextBorderStyleLine];
    [nameField setFont:[UIFont systemFontOfSize:16]];
    [nameField setPlaceholder:@"Name"];
    [nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameField setKeyboardType:UIKeyboardTypeDefault];
    [nameField setReturnKeyType:UIReturnKeyDone];
    [nameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nameField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [nameField]
    
//    textField.delegate = self;
//    [self.view addSubview:textField];
    CGRect cardRect = CGRectMake(20, textHeight, textWidth, textHeight);
    cardNumberField= [[UITextField alloc]initWithFrame:cardRect];
    [cardNumberField setBorderStyle:UITextBorderStyleLine];
    [cardNumberField setFont:[UIFont systemFontOfSize:16]];
    [cardNumberField setPlaceholder:@"XXXX XXXX XXXX XXXX"];
    [cardNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [cardNumberField setKeyboardType:UIKeyboardTypeDefault];
    [cardNumberField setReturnKeyType:UIReturnKeyDone];
    [cardNumberField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [cardNumberField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [cardNumberField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    CGRect expireRect  = CGRectMake(20, textHeight*2, textWidth, textHeight);
    expirationField = [[UITextField alloc]initWithFrame:expireRect];
    [expirationField setBorderStyle:UITextBorderStyleLine];
    [expirationField setFont:[UIFont systemFontOfSize:16]];
    [expirationField setPlaceholder:@"Expiration"];
    [expirationField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [expirationField setKeyboardType:UIKeyboardTypeDefault];
    [expirationField setReturnKeyType:UIReturnKeyDone];
    [expirationField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [expirationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [expirationField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    CGRect securityRect  = CGRectMake(20, textHeight*3, textWidth, textHeight);
    securityCodeField = [[UITextField alloc]initWithFrame:securityRect];
    [securityCodeField setBorderStyle:UITextBorderStyleLine];
    [securityCodeField setFont:[UIFont systemFontOfSize:16]];
    [securityCodeField setPlaceholder:@"Security Code"];
    [securityCodeField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [securityCodeField setKeyboardType:UIKeyboardTypeDefault];
    [securityCodeField setReturnKeyType:UIReturnKeyDone];
    [securityCodeField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [securityCodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [securityCodeField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}


-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=@"Payment Inputs";
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)createPaymentButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3.0f;
    [bottomButton addTarget:self action:@selector(pushPay) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    [self.view addSubview:bottomView];
    
}

-(void)pushPay{
    
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
