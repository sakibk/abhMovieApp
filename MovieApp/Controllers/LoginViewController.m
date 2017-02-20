//
//  LoginViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "Token.h"
#import "UserInfo.h"

@interface LoginViewController ()

@property Token *token;
@property Token *sessionToken;
@property Token *session;
@property UserInfo *currentUser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLoginView];
    [self setRestkit];
    [self getToken];
    [self setLoginRestkit];
    [self setSessionRestkit];
    [self setAccountRestkit];
    //[NSUserDefaults standardUserDefaults]
    // dodati restkit za statuscode 401 i provjeriti tekst koji se dobije ako nije nil !!
}

-(IBAction)sessionPressed:(id)sender{
    [self getTokenForSesion];
    [self.passwordEditor resignFirstResponder];
}

-(void)setLoginView{
    _loginButton.layer.cornerRadius = 29;
    _loginButton.clipsToBounds = YES;
    
    _statusLabel.layer.cornerRadius=29;
    _statusLabel.clipsToBounds = YES;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_statusLabel setHidden:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
    UIImage* logoImage = [UIImage imageNamed:@"LoginTitle"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    [self.passwordEditor setValue:[UIColor whiteColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailEditor setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateFocused];
    [_loginButton addTarget:self action:@selector(sessionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postStatusError:(NSString*)error{
    [_statusLabel setText:error];
    [_statusLabel setHidden:NO];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:2.7];
}

-(void)hideLabel{
    [UIView animateWithDuration:0.3 animations:^{
        [_statusLabel setHidden:YES];
    } completion:^(BOOL finished){
        
    }];
}

-(void)setRestkit{
    NSString *pathP = @"/3/authentication/token/new";
    RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[Token class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    [tokenMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                       @"expires_at": @"expireDate",
                                                       @"status_code": @"statusCode",
                                                       @"status_message": @"statusMessage",
                                                       @"request_token": @"requestToken"
                                                       }];
    
    tokenMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *tokenResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tokenMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:tokenResponseDescriptor];
    
}

-(void)getToken{
    
    NSString *pathP = @"/3/authentication/token/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _token=mappingResult.array.firstObject;
        if(_token.statusCode!=nil){
            [self postStatusError:@"Wrong api key"];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}



-(void)setLoginRestkit{
    
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    RKObjectMapping *sessionTokenMapping = [RKObjectMapping mappingForClass:[Token class]];
    
    NSString *pathP = @"/3/authentication/token/validate_with_login";
    
    [sessionTokenMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                       @"status_code": @"statusCode",
                                                       @"status_message": @"statusMessage",
                                                       @"request_token": @"requestToken"
                                                       }];

    sessionTokenMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *sessionTokenResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sessionTokenMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    

    [[RKObjectManager sharedManager] addResponseDescriptor:sessionTokenResponseDescriptor];
}


-(void)getTokenForSesion{
    NSString *token=_token.requestToken;
    
    NSString *pathP = @"/3/authentication/token/validate_with_login";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"request_token":token,
                                      @"username":_emailEditor.text,
                                      @"password":_passwordEditor.text
                                      };

    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _sessionToken=mappingResult.array.firstObject;
            [self getSesion];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Username or Password"];
    }];
}

-(void)setSessionRestkit{
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[Token class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    NSString *pathP = @"/3/authentication/session/new";
    
    [sessionMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                              @"status_code": @"statusCode",
                                                              @"status_message": @"statusMessage",
                                                              @"session_id": @"sessionID"
                                                              }];
    
    sessionMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *sessionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sessionMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:sessionResponseDescriptor];
}

-(void)getSesion{
    NSString *token=_sessionToken.requestToken;
    
    NSString *pathP = @"/3/authentication/session/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"request_token":token
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _session=mappingResult.array.firstObject;
        _session.logedUsername=_emailEditor.text;
        _session.requestToken=token;
             [self postStatusError:@"Successfuly Logged"];
        [self getAccountDetails];
       // [[NSUserDefaults standardUserDefaults] setObject:_session forKey:@"session"];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Api key or request token"];
    }];
}

-(void)setAccountRestkit{
    RKObjectMapping *accountMapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    NSString *pathP = @"/3/account";
    
    [accountMapping addAttributeMappingsFromDictionary:@{@"id": @"userID",
                                                         @"name": @"name",
                                                         @"username": @"userName"
                                                         }];
    
    accountMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *accountResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:accountMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:pathP
                                                                                                  keyPath:nil
                                                                                              statusCodes:statusCodesRK];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:accountResponseDescriptor];
}

-(void)getAccountDetails{
    
    NSString *pathP = @"/3/account";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _currentUser=mappingResult.array.firstObject;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoged"];
        NSDictionary *loginData = @{@"userID":_currentUser.userID,
                                    @"sessionID":_session.sessionID,
                                    @"token":_session.requestToken,
                                    @"username":_currentUser.userName,
                                    @"name":_currentUser.name,
                                    @"apiKey": @"893050c58b2e2dfe6fa9f3fae12eaf64"
                                    };
        [[NSUserDefaults standardUserDefaults] setObject:loginData forKey:@"SessionCredentials"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Api key or request token"];
    }];
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
