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
    [_movieNotification addTarget:self action:@selector(movieNotificationON:) forControlEvents:UIControlEventAllEvents];
    [_showNotification addTarget:self action:@selector(showNotificationON:) forControlEvents:UIControlEventAllEvents];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"SessionCredentials"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)movieNotificationON:(id)sender{
    BOOL isSet = [[_userCredits valueForKey:@"movieNotification"] boolValue];
    NSMutableDictionary *tempUserCredits= [[NSMutableDictionary alloc]initWithDictionary: _userCredits];
    if(isSet){
        [tempUserCredits setValue:[NSNumber numberWithBool:NO] forKey:@"movieNotification"];
    }
    else{
        [tempUserCredits setValue:[NSNumber numberWithBool:YES] forKey:@"movieNotification"];
    }
    NSDictionary *updated = [[NSDictionary alloc]initWithDictionary:tempUserCredits];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:updated forKey:@"SessionCredentials"];
    [defaults synchronize];
}

-(IBAction)showNotificationON:(id)sender{
    BOOL isSet = [[_userCredits valueForKey:@"showNotification"] boolValue];
        NSMutableDictionary *tempUserCredits= [[NSMutableDictionary alloc]initWithDictionary: _userCredits];
    if(isSet){
        [tempUserCredits setValue:[NSNumber numberWithBool:NO] forKey:@"showNotification"];
    }
    else{
        [tempUserCredits setValue:[NSNumber numberWithBool:YES] forKey:@"showNotification"];
    }
    
    NSDictionary *updated = [[NSDictionary alloc]initWithDictionary:tempUserCredits];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:updated forKey:@"SessionCredentials"];
    [defaults synchronize];
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
    self.navigationItem.title =@"Settings";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"SessionCredentials"];
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
