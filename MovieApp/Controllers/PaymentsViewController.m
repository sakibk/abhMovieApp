//
//  PaymentsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 05/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PaymentsViewController.h"
#import  <QuartzCore/QuartzCore.h>
#import "ApiKey.h"
#import "SuccessfulPaymentViewController.h"

@import Firebase;
@import Stripe;

@interface PaymentsViewController ()

@property FIRDatabaseReference *seatsRef;
@property STPCardParams *cardParams;
@property NSString *cardHolder;
@property NSString *cardNumber;
@property NSString *cardExpire;
@property NSString *cardCVC;
@property NSNumber *cardCVCN;
@property NSNumber *cardExpireMonth;
@property NSNumber *cardExpireYear;
@property NSNumber *cardNumberN;
@property UILabel *statusLabel;

@end

@implementation PaymentsViewController
{
    UIView *bottomView;
    UIView *topButtonsView;
    UIView *textFieldsView;
    UIView *separatorOne;
    UIView *separatorTwo;
    UIView *separatorThree;
    UIView *separatorFour;
    UITextField *nameField;
    UITextField *cardNumberField;
    UITextField *expirationField;
    UITextField *securityCodeField;
    UIButton *bottomButton;
    UIButton *visa;
    UIButton *master;
    BOOL isVisa;
    BOOL isSet;
    NSNumber *previusCardLocation;
    NSNumber *previusExpireLocation;
    UILabel *expireLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cardParams = [[STPCardParams alloc]init];
    [self setupWatchingReferences];
    [self setupStatusLabel];
    [self createButtonsView];
    [self createTextfieldViews];
    [self createPaymentButton];
    [self setNavBarTitle];
    [self setupVariables];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [_seatsRef removeAllObservers];
}

-(void)setupVariables{
    _cardNumber=[[NSString alloc] init];
    _cardExpire = [[NSString alloc]init];
    _cardCVC=[[NSString alloc] init];
    _cardHolder=[[NSString alloc] init];
    isSet=NO;
    previusCardLocation = [NSNumber numberWithInt:0];
    previusExpireLocation = [NSNumber numberWithInt:0];
}

-(void)setupStatusLabel{
    CGRect statusRect = CGRectMake(20, self.view.bounds.size.height*5/7, self.view.bounds.size.width-40, 50);
    _statusLabel= [[UILabel alloc]initWithFrame:statusRect];
    [_statusLabel setBackgroundColor:[UIColor darkGrayColor]];
    [[_statusLabel layer] setCornerRadius:24.0];
    _statusLabel.clipsToBounds = YES;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_statusLabel];
    [_statusLabel setHidden:YES];
}

-(void)postStatus:(NSString*)error{
    [_statusLabel setText:error];
    [_statusLabel setHidden:NO];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:1.7];
}

-(void)hideLabel{
    [UIView animateWithDuration:0.3 animations:^{
        [_statusLabel setHidden:YES];
    } completion:^(BOOL finished){
        
    }];
}

-(void)setupWatchingReferences{
    [self.seatsRef removeAllObservers];
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    _seatsRef = [[[[[ref child:@"Halls"] child:[NSString stringWithFormat:@"%@",_playingTerm.playingHall]] child:[NSString stringWithFormat:@"%@",_playingTerm.playingDayID]] child:[NSString stringWithFormat:@"%@",_playingTerm.hourID]] child:@"Seats"];
    
    [_seatsRef
     observeEventType:FIRDataEventTypeChildChanged
     withBlock:^(FIRDataSnapshot *snapshot) {
         int i;
         NSInteger j =[_selectedSeats count];
         for(i=0; i <j ; i++){
             NSLog(@"String value: %@",[[_selectedSeats objectAtIndex:i]row]);
             if([[snapshot.value valueForKey:@"row"] isEqualToString:[[_selectedSeats objectAtIndex:i] row]]){
                 if([[snapshot.value valueForKey:@"taken"] boolValue]){
                     NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
                     [viewControllers removeLastObject];
                     [viewControllers removeLastObject];
                     [[self navigationController] setViewControllers:viewControllers animated:YES];
                 }
             }
         }
     }];
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
        isSet = YES;
        isVisa=YES;
        [visa setTitleColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [visa setBackgroundColor:[UIColor blackColor]];
        [[visa layer] setBorderColor:[[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] CGColor]];
        [master setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [master setBackgroundColor:[UIColor darkGrayColor]];
        [[master layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    }else{
        isVisa=NO;
        isSet = YES;
        [master setTitleColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [master setBackgroundColor:[UIColor blackColor]];
        [[master layer] setBorderColor:[[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0] CGColor]];
        [visa setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [visa setBackgroundColor:[UIColor darkGrayColor]];
        [[visa layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    }
}

-(void)createTextfieldViews{
    CGRect textfieldViewRect= CGRectMake(0, 145, self.view.bounds.size.width, self.view.bounds.size.width*3/7);
    textFieldsView=[[UIView alloc]initWithFrame:textfieldViewRect];
    CGFloat textHeight = textfieldViewRect.size.height/4;
    CGFloat textWidth =textfieldViewRect.size.width-40;
    CGRect nameRect = CGRectMake(20, 0, textWidth, textHeight);
    nameField = [[UITextField alloc]initWithFrame:nameRect];
    [nameField setBorderStyle:UITextBorderStyleLine];
    [nameField setFont:[UIFont systemFontOfSize:16]];
    [nameField setTextAlignment:NSTextAlignmentLeft];
    [nameField setTextColor:[UIColor darkGrayColor]];
    [nameField setPlaceholder:@"Name"];
    [nameField setValue:[UIColor darkGrayColor]
             forKeyPath:@"_placeholderLabel.textColor"];
    [nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameField setKeyboardType:UIKeyboardTypeDefault];
    [nameField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [nameField setReturnKeyType:UIReturnKeyDone];
    [nameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nameField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    separatorOne =[[UIView alloc]initWithFrame:CGRectMake(0, nameRect.size.height-5, nameRect.size.width, 1)];
    [separatorOne setBackgroundColor:[UIColor darkGrayColor]];
    [nameField addSubview:separatorOne];
    [nameField setTag:1];
    nameField.delegate=self;
    
    [textFieldsView addSubview:nameField];
    
    
    CGRect cardRect = CGRectMake(20, textHeight, textWidth, textHeight);
    cardNumberField= [[UITextField alloc]initWithFrame:cardRect];
    [cardNumberField setBorderStyle:UITextBorderStyleLine];
    [cardNumberField setFont:[UIFont systemFontOfSize:16]];
    [cardNumberField setPlaceholder:@"XXXX XXXX XXXX XXXX"];
    [cardNumberField setValue:[UIColor darkGrayColor]
                   forKeyPath:@"_placeholderLabel.textColor"];
    [cardNumberField setTextAlignment:NSTextAlignmentLeft];
    [cardNumberField setTextColor:[UIColor darkGrayColor]];
    [cardNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [cardNumberField setKeyboardType:UIKeyboardTypeNumberPad];
    [cardNumberField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [cardNumberField setReturnKeyType:UIReturnKeyDone];
    [cardNumberField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [cardNumberField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [cardNumberField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    separatorTwo =[[UIView alloc]initWithFrame:CGRectMake(0, cardRect.size.height-5, cardRect.size.width, 1)];
    [separatorTwo setBackgroundColor:[UIColor darkGrayColor]];
    [cardNumberField addSubview:separatorTwo];
    [cardNumberField setTag:2];
    cardNumberField.delegate=self;
    
    [textFieldsView addSubview:cardNumberField];
    
    
    CGRect expireRect  = CGRectMake(20, textHeight*2, textWidth, textHeight);
    expirationField = [[UITextField alloc]initWithFrame:expireRect];
    [expirationField setBorderStyle:UITextBorderStyleLine];
    [expirationField setFont:[UIFont systemFontOfSize:16]];
    [expirationField setPlaceholder:@"Expiration"];
    [expirationField setValue:[UIColor darkGrayColor]
                   forKeyPath:@"_placeholderLabel.textColor"];
    [expirationField setTextAlignment:NSTextAlignmentLeft];
    [expirationField setTextColor:[UIColor darkGrayColor]];
    [expirationField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [expirationField setKeyboardType:UIKeyboardTypeNumberPad];
    [expirationField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [expirationField setReturnKeyType:UIReturnKeyDone];
    [expirationField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [expirationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [expirationField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    separatorThree =[[UIView alloc]initWithFrame:CGRectMake(0, expireRect.size.height-5, expireRect.size.width, 1)];
    [separatorThree setBackgroundColor:[UIColor darkGrayColor]];
    [expirationField addSubview:separatorThree];
    [expirationField setTag:3];
    expirationField.delegate=self;
    expireLabel = [[UILabel alloc]initWithFrame:CGRectMake(expirationField.bounds.size.width-70, 0, 70, textHeight)];
    [expireLabel setFont:[UIFont systemFontOfSize:16]];
    [expireLabel setTextColor:[UIColor darkGrayColor]];
    [expireLabel setText:@"MM/YY"];
    [expirationField addSubview:expireLabel];
    
    [textFieldsView addSubview:expirationField];
    
    
    CGRect securityRect  = CGRectMake(20, textHeight*3, textWidth, textHeight);
    securityCodeField = [[UITextField alloc]initWithFrame:securityRect];
    [securityCodeField setBorderStyle:UITextBorderStyleLine];
    [securityCodeField setFont:[UIFont systemFontOfSize:16]];
    [securityCodeField setPlaceholder:@"Security Code"];
    [securityCodeField setValue:[UIColor darkGrayColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
    [securityCodeField setTextAlignment:NSTextAlignmentLeft];
    [securityCodeField setTextColor:[UIColor darkGrayColor]];
    [securityCodeField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [securityCodeField setKeyboardType:UIKeyboardTypeNumberPad];
    [securityCodeField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [securityCodeField setReturnKeyType:UIReturnKeyDone];
    [securityCodeField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [securityCodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [securityCodeField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    separatorFour =[[UIView alloc]initWithFrame:CGRectMake(0, securityRect.size.height-5, securityRect.size.width, 1)];
    [separatorFour setBackgroundColor:[UIColor darkGrayColor]];
    [securityCodeField addSubview:separatorFour];
    [securityCodeField setTag:4];
    securityCodeField.delegate=self;
    
    [textFieldsView addSubview:securityCodeField];
    
    
    [self.view addSubview:textFieldsView];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch ([textField tag]) {
        case 1:{
            
        }
            break;
            
        case 2:{
            if(range.location>19){
                if([cardNumberField canResignFirstResponder]){
                    [cardNumberField resignFirstResponder];
                    if([expirationField canBecomeFirstResponder]){
                        [expirationField becomeFirstResponder];
                    }
                }
            } else {
                if(range.location<5){
                if(range.location%4==0 && range.location!=0){
                    if([previusCardLocation integerValue]<range.location){
                    cardNumberField.text = [NSString stringWithFormat:@"%@ ",cardNumberField.text];
                    }else{
                        cardNumberField.text = [cardNumberField.text substringToIndex:[cardNumberField.text length]-1];
                    }
                }
                }else{
                    if(range.location%5==0){
                        if([previusCardLocation integerValue]<range.location){
                            cardNumberField.text = [NSString stringWithFormat:@"%@ ",cardNumberField.text];
                        }else{
                            cardNumberField.text = [cardNumberField.text substringToIndex:[cardNumberField.text length]-1];
                        }
                    }

                }
                
                previusCardLocation=[NSNumber numberWithUnsignedInteger: range.location];
                if(![cardNumberField isUserInteractionEnabled])
                    [cardNumberField setUserInteractionEnabled:YES];
            }
        }
            break;
        case 3:{
            if(range.location>4){
                if([expirationField canResignFirstResponder]){
                    [expirationField resignFirstResponder];
                    if([securityCodeField canBecomeFirstResponder]){
                        [securityCodeField becomeFirstResponder];
                    }
                }
            }
            else if(range.location==2){
                if([previusExpireLocation integerValue]<range.location){
                expirationField.text = [NSString stringWithFormat:@"%@/",expirationField.text];
                }else{
                    expirationField.text = [expirationField.text substringToIndex:[expirationField.text length]-2];
                }
            }else{
                if(![expirationField isUserInteractionEnabled])
                    [expirationField setUserInteractionEnabled:YES];
            }
        }
            break;
        case 4:{
            if(range.location>2){
                if([securityCodeField canResignFirstResponder]){
                    [securityCodeField resignFirstResponder];
                }
            }else {
                if(![securityCodeField isUserInteractionEnabled])
                    [securityCodeField setUserInteractionEnabled:YES];
            }
        }
            break;
            
        default:
            break;
    }
    NSLog(@"TEXTFIELD TAG: %ld",[textField tag]);
    NSLog(@"IN RANGE: %lu,%lu",(unsigned long)range.length,(unsigned long)range.location);
    NSLog(@"WITH STRING: %@",string);
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text length]==0 || ![textField.text length]){
        [separatorOne setBackgroundColor:[UIColor darkGrayColor]];
    }
    switch ([textField tag]) {
        case 1:{
            [nameField setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
            _cardHolder=nameField.text;
        }
            break;
            
        case 2:{
            [cardNumberField setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
            _cardNumber = cardNumberField.text;
        }
            break;
        case 3:{
            [expirationField setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
            _cardExpire = expirationField.text;
        }
            break;
        case 4:{
            [securityCodeField setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
            _cardCVC=securityCodeField.text;
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField canResignFirstResponder])
        [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField canBecomeFirstResponder])
        [textField becomeFirstResponder];
    switch ([textField tag]) {
        case 1:{
            [nameField setTextColor:[UIColor darkGrayColor]];
            [separatorOne setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
        }
            break;
            
        case 2:{
            [cardNumberField setTextColor:[UIColor darkGrayColor]];
            [separatorTwo setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
        }
            break;
        case 3:{
            [expirationField setTextColor:[UIColor darkGrayColor]];
            [separatorThree setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
        }
            break;
        case 4:{
            [securityCodeField setTextColor:[UIColor darkGrayColor]];
            [separatorFour setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
        }
            break;
            
        default:
            break;
    }
}

-(void)pushPay{
    NSArray* expires = [_cardExpire componentsSeparatedByString: @"/"];
    if(isSet){
        if([_cardHolder length]>0 || ![_cardHolder length]){
    if([expires count]==2){
        _cardExpireMonth =[NSNumber numberWithInt:[[expires objectAtIndex: 0] intValue]];
        _cardExpireYear =[NSNumber numberWithInt:[[expires objectAtIndex: 1] intValue]];
        if([_cardNumber length]<20){
            [self postStatus:@"Unvalid Card Number"];
        }
        else if([_cardExpireMonth intValue]>12 || [_cardExpireMonth intValue]<4){
            [self postStatus:@"Unvalid Expire Month"];
        }
        else if([_cardExpireYear intValue]>27 || [_cardExpireYear intValue]<17){
            [self postStatus:@"Unvalid Expire year"];
        }
        else if([_cardCVC length]<3){
            [self postStatus:@"Unvalid CVC number"];
        }
        else{
            _cardNumberN = [NSNumber numberWithInteger:[[_cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""] integerValue]];
            _cardCVCN=[NSNumber numberWithInteger:[_cardCVC integerValue]];
            NSLog(@" @@@@@@@ CARD NO : %@ @@@@@@",_cardNumberN);
            NSLog(@" @@@@@@@ CARD EXPIRE YEAR : %@ @@@@@@",_cardExpireYear);
            NSLog(@" @@@@@@@ CARD EXPIRE MONTH : %@ @@@@@@",_cardExpireMonth);
            NSLog(@" @@@@@@@ CARD CVC : %@ @@@@@@",_cardCVCN);
            [self createTokenNonClient];
        }
    }else{
        [self postStatus:@"Unvalid expire date"];
    }
        }else{
            [self postStatus:@"Please input your name"];
        }
    }else{
        [self postStatus:@"Please select card type"];
    }
    
    //    [self createTokenNonClient];
}

-(void)createToken{
    [[STPAPIClient sharedClient] createTokenWithCard:_cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            // show the error, maybe by presenting an alert to the user
            [self postStatus:@"Invalid Card Credentials"];
        } else {
            // ovdje implementirati da posaljem token negdje ..
            [self payWithStripe:token];
        }
    }];
}

-(void)createTokenNonClient{
    NSError *error;
    
    NSString *pathP = @"https://noodlio-pay.p.mashape.com/tokens/create";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{
                                            @"X-Mashape-Key": [ApiKey getMashableApiKey],
                                            @"Content-Type": @"application/x-www-form-urlencoded",
                                            @"Accept": @"application/json"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:pathP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *parameters = @{@"cvc": @(123),
                                 @"exp_month": @(12),
                                 @"exp_year": @(2020),
                                 @"number": @(4242424242424242),
                                 @"test":@"true"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error){
            NSLog(@"%@",dict);
            [self payWithStripe:[dict valueForKey:@"id"]];
        }
        else{
            [self postStatus:@"Invalid Card Credentials"];
        }
    }];
    
    [postDataTask resume];
}


-(void)payWithStripe:(STPToken*)token{
    NSError *error;
    
    NSString *pathP = @"https://noodlio-pay.p.mashape.com/charge/token";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{
                                            @"X-Mashape-Key": [ApiKey getMashableApiKey],
                                            @"Content-Type": @"application/x-www-form-urlencoded",
                                            @"Accept": @"application/json"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:pathP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *parameters = @{@"amount": @([_totalAmount floatValue]*100),
                                 @"currency": @"usd",
                                 @"description":_accountID,
                                 @"statement_descriptor":_seatsSelected,
                                 @"source": [NSString stringWithFormat:@"%@",token],
                                 @"stripe_account": [ApiKey getStripeAccountID],
                                 @"test":@"true"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSThread currentThread] isMainThread]){
                if(!error){
                    NSLog(@"%@",dict);
                    [_seatsRef removeAllObservers];
                    [self updatePayedSeats];
                }
                else{
                    [self postStatus:@"Invalid Card Credentials"];
                }
            }
            else{
                NSLog(@"Not in main thread--completion handler");
            }
        });
    }];
    
    [postDataTask resume];
}

-(void)updatePayedSeats{
    int i;
    NSInteger j =[_selectedSeats count];
    for(i=0; i <j ; i++){
        NSLog(@"String value: %@",[[_selectedSeats objectAtIndex:i]row]);
        [[[_seatsRef child:[NSString stringWithFormat:@"%@",[[_selectedSeats objectAtIndex:i] seatID]]] child:@"taken"] setValue:@"YES"];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SuccessfulPaymentViewController *succesfullPaymentVC = (SuccessfulPaymentViewController*)[storyboard instantiateViewControllerWithIdentifier:@"succesfullPaymentVC"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers addObject:succesfullPaymentVC];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
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
