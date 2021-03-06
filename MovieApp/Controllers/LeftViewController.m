//
//  LeftViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "LeftViewCell.h"
#import "LoginViewController.h"
#import "ListsViewController.h"
#import "SettingsViewController.h"
#import "FirebaseViewController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *logedTitlesArray;
@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) NSArray *imageTitlesArray;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@property (nonatomic) BOOL isLogged;
@property (nonatomic) BOOL wasLogged;
@property (nonatomic) BOOL changedState;

@end

@implementation LeftViewController
{
    UIView *headerView;
    BOOL didSet;
}



- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.titlesArray = @[@"",
                             @"",
                             @"Login",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @""];
        
        self.logedTitlesArray = @[@"Your List",
                                  @"Your Favorites",
                                  @"Your Watchlist",
                                  @"Your Ratings",
                                  @"More",
                                  @"Cinema",
                                  @"Settings",
                                  @"Logout",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @""];
        
        self.imagesArray = @[@"",
                             @"FavoritesButton",
                             @"WatchlistButton",
                             @"RatingsButton",
                             @"",
                             @"CinemaIcon",
                             @"SettingsButton",
                             @"LogoutButton",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @""];
        
        self.imageTitlesArray = @[@"",
                                  @"",
                                  @"LoginArrow",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @"",
                                  @""];
        
        [self.tableView setScrollEnabled:NO];
        
        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 124.0, 0.0);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        _wasLogged=NO;
        _changedState=NO;
        didSet=NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.sideMenuController.delegate=self;
}

-(void)hideAnimationsBlockForLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration{
    
}
-(void)showAnimationsBlockForLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration{
    
}

-(void)didShowLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController{
    
}

-(void)willShowLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController{
    
}

-(void)willHideLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController{
    
}

-(void)didHideLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController{
    
}

- (void)viewWillAppear:(BOOL)animated {
    _isLogged = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(_isLogged!=_wasLogged){
        _changedState=YES;
        _wasLogged=_isLogged;
    }
    
    _selectedIndex=nil;
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [_menuButton setAlpha:1.0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_menuButton setAlpha:0.0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    headerView = [[UIView alloc] init];
    _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 29, 25, 25)];
    [_menuButton setImage:[UIImage imageNamed:@"PieIcon"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(pieIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_menuButton];
    return headerView;
}

-(IBAction)pieIconPressed:(id)sender{
    [_menuButton setAlpha:0.0];
    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:^(void){
        [_menuButton setAlpha:1.0];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell setUserInteractionEnabled:NO];
    [cell.textLabel setMinimumScaleFactor:0.85];
    if(!_isLogged){
        cell.textLabel.text = self.titlesArray[indexPath.row];
        cell.separatorView.hidden = (indexPath.row >=2 || indexPath.row<1);
        if(![self.imagesArray[indexPath.row] isEqualToString:@""]){
            [cell.imageView setImage:[UIImage imageNamed:self.imageTitlesArray[indexPath.row]]];
            [cell.imageView sizeToFit];
        }
        if(indexPath.row==2){
            [cell setUserInteractionEnabled:YES];
        }
    }
    else if (_isLogged){
        cell.textLabel.text = self.logedTitlesArray[indexPath.row];
        cell.separatorView.hidden = (indexPath.row !=2 || indexPath.row!=3 || indexPath.row!=6);
        if(![self.imagesArray[indexPath.row] isEqualToString:@""]){
            [cell.imageView setImage:[UIImage imageNamed:self.imagesArray[indexPath.row]]];
            [cell.imageView sizeToFit];
            [cell setUserInteractionEnabled:YES];
            if([self.imagesArray[indexPath.row] isEqualToString:@"CinemaIcon"]){
                if(!didSet){
                    [cell setupNewButton];
                    didSet=YES;
                }
                [[cell imageIconNew] setAlpha:1.0];
                [cell setBackgroundColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.28 alpha:1.0]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0.96 green:0.79 blue:0 alpha:1.0]];
            }
        }
        else if(indexPath.row==0 || indexPath.row==4){
            [cell setBackgroundColor:[UIColor colorWithRed:0.19 green:0.19 blue:0.20 alpha:1.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height/16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped");
    if(_changedState){
        _selectedIndex = nil;
        _changedState = NO;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeftViewCell *cell = (LeftViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.28 alpha:1.0]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.96 green:0.79 blue:0 alpha:1.0]];
    if(_isLogged){
        if(_selectedIndex !=indexPath){
            LeftViewCell *previusCell = (LeftViewCell*)[tableView cellForRowAtIndexPath:_selectedIndex];
            [previusCell.textLabel setTextColor:[UIColor lightGrayColor]];
            [previusCell setBackgroundColor:[UIColor blackColor]];
            [previusCell.imageView setImage:[UIImage imageNamed:self.imagesArray[_selectedIndex.row]]];
            switch (indexPath.row) {
                case 1:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowFavoritesButton"]];
                    ListsViewController *listsController = (ListsViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                    listsController.isFavorites=YES;
                    listsController.isWatchlist=NO;
                    listsController.isRating=NO;
                    [self.navigationController pushViewController:listsController animated:YES];
                    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                }
                    break;
                case 2:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowWatchlistButton"]];
                    ListsViewController *listsController = (ListsViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                    listsController.isFavorites=NO;
                    listsController.isWatchlist=YES;
                    listsController.isRating=NO;
                    [listsController.navigationController setNavigationBarHidden:NO];
                    [self.navigationController pushViewController:listsController animated:YES];
                    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                }
                    break;
                case 3:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowRatingsButton"]];
                    ListsViewController *listsController = (ListsViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                    listsController.isFavorites=NO;
                    listsController.isWatchlist=NO;
                    listsController.isRating=YES;
                    [self.navigationController pushViewController:listsController animated:YES];
                    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                }
                    break;
                case 5:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowCinema"]];
                    FirebaseViewController *firebaseController = (FirebaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FirebaseViewController"];
                    [self.navigationController pushViewController:firebaseController animated:YES];
                    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                }
                    break;
                case 6:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowSettingsButton"]];
                    SettingsViewController *settingsView = (SettingsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                    [self.navigationController pushViewController:settingsView animated:YES];
                    [_menuButton setAlpha:0.0];
                    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                }
                    break;
                case 7:{
                    [cell.imageView setImage:[UIImage imageNamed:@"YellowLogoutButton"]];
                    [_menuButton setAlpha:0.0];
                    [self.sideMenuController hideLeftViewAnimated:NO completionHandler:nil];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout" message:@"Are You sure You want to logout?" preferredStyle:UIAlertControllerStyleAlert];
                    UIView *firstSubview = alertController.view.subviews.firstObject;
                    
                    UIView *alertContentView = firstSubview.subviews.firstObject;
                    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
                        subSubView.backgroundColor = [UIColor colorWithWhite:0.177 alpha:1.0]; //Here you change background
                    }
                    NSMutableAttributedString *titleText =
                    [[NSMutableAttributedString alloc]
                     initWithString:@"Logout"];
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 30.f;
                    paragraphStyle.alignment = NSTextAlignmentCenter;
                    
                    [titleText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleText length])];
                    [titleText addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor whiteColor]
                                      range:NSMakeRange(0, [titleText length])];
                    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, [titleText length])];
                    NSMutableAttributedString *text =
                    [[NSMutableAttributedString alloc]
                     initWithString:@"\nAre You sure You want to logout?"];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor lightGrayColor]
                                 range:NSMakeRange(0, [text length])];
                    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [text length])];
                    
                    [alertController setValue:titleText forKey:@"attributedTitle"];
                    [alertController setValue:text forKey:@"attributedMessage"];
                    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoged"];
                        _isLogged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
                        [self.tableView reloadData];
                    }];
                    
                    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        _selectedIndex=nil;
                    }];
                    alertController.view.tintColor =[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0];
                    [alertController addAction:no];
                    [alertController addAction:yes];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
            _selectedIndex=indexPath;
        }
        
    }
    else{
        if(_selectedIndex!=indexPath){
            if(indexPath.row==2){
                [cell.imageView setImage:[UIImage imageNamed:@"YellowLoginArrow"]];
                LoginViewController *loginController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
                [self.navigationController pushViewController:loginController animated:YES];
                [_menuButton setAlpha:0.0];
                [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
            }
        }
        _selectedIndex=indexPath;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginControllerIdentifier"]){
        LoginViewController *login = segue.destinationViewController;
    }
}



@end
