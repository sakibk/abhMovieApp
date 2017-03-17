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
@property BOOL isMovieSet;
@property BOOL isShowSet;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [_movieNotification setTag:1];
    [_showNotification setTag:2];
    [_movieNotification addTarget:self action:@selector(movieNotificationON:) forControlEvents:UIControlEventValueChanged];
    [_showNotification addTarget:self action:@selector(showNotificationON:) forControlEvents:UIControlEventValueChanged];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"SessionCredentials"
                                               options:NSKeyValueObservingOptionNew
                                               context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)movieNotificationON:(id)sender{
    if(_isMovieSet && [sender tag]==1){
        _isMovieSet=NO;
    }
    else if(!_isMovieSet && [sender tag]==1){
        _isMovieSet=YES;
    }
}

-(IBAction)showNotificationON:(id)sender{
    if(_isShowSet && [sender tag]==2){
        _isShowSet=NO;
    }
    else if (!_isShowSet && [sender tag]==2){
        _isShowSet=YES;
    }
}

-(void)setupView{
    //    .contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    _accountName.text=[_userCredits valueForKey:@"name"];
    _accountUsername.text =[_userCredits valueForKey:@"username"];
    [_movieNotification setOn:[[_userCredits valueForKey:@"movieNotification"] boolValue]animated:YES];
    [_showNotification setOn:[[_userCredits valueForKey:@"showNotification"] boolValue]animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
    _movieNotification.layer.cornerRadius = 16.0;
    _showNotification.layer.cornerRadius = 16.0;
    _isMovieSet= [[_userCredits valueForKey:@"movieNotification"] boolValue];
    _isShowSet= [[_userCredits valueForKey:@"showNotification"] boolValue];
    self.navigationItem.title =@"Settings";
}

-(void)viewWillDisappear:(BOOL)animated{
    NSMutableDictionary *tempUserCredits= [[NSMutableDictionary alloc]initWithDictionary: _userCredits];
    if(!_isShowSet && !_isMovieSet){
        [tempUserCredits setValue:[NSNumber numberWithInt:0] forKey:@"showNotification"];
        [tempUserCredits setValue:[NSNumber numberWithInt:0] forKey:@"movieNotification"];
    }
    else if(_isShowSet && _isMovieSet){
        [tempUserCredits setValue:[NSNumber numberWithInt:1] forKey:@"showNotification"];
        [tempUserCredits setValue:[NSNumber numberWithInt:1] forKey:@"movieNotification"];
    }
    else if(!_isMovieSet && _isShowSet){
        [tempUserCredits setValue:[NSNumber numberWithInt:0] forKey:@"movieNotification"];
        [tempUserCredits setValue:[NSNumber numberWithInt:1] forKey:@"showNotification"];
    }
    else{
        [tempUserCredits setValue:[NSNumber numberWithInt:1] forKey:@"movieNotification"];
        [tempUserCredits setValue:[NSNumber numberWithInt:0] forKey:@"showNotification"];
    }
    NSDictionary *newUserCredits = [[NSDictionary alloc] initWithDictionary:tempUserCredits];
    [[NSUserDefaults standardUserDefaults] setObject:newUserCredits forKey:@"SessionCredentials"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"SessionCredentials"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context
{
    if([keyPath isEqual:@"SessionCredentials"])
    {
        NSLog(@"SomeKey change: %@", change);
    }
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
