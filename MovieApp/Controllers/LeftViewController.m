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
                                 @"",
                                 @""];
            
            self.imagesArray = @[@"",
                                 @"FavoritesButton",
                                 @"WatchlistButton",
                                 @"RatingsButton",
                                 @"",
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
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [headerView setAlpha:0.0];
    
    
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
    [headerView setAlpha:0.0];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [headerView setAlpha:1.0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [headerView setAlpha:0.0];
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
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 29, 25, 25)];
    [menuButton setImage:[UIImage imageNamed:@"PieIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(pieIconPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:menuButton];
    return headerView;
}

-(IBAction)pieIconPressed:(id)sender{
    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
    [sender setAlpha:0.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell setBackgroundColor:[UIColor blackColor]];
     [cell setUserInteractionEnabled:NO];
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
        }
    else if(indexPath.row==0 || indexPath.row==4){
        [cell setBackgroundColor:[UIColor darkGrayColor]];
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
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:248.0 green:202.0 blue:0 alpha:100.0]];
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
                [self.sideMenuController showLeftViewAnimated:NO completionHandler:nil];
            }
                break;
            case 2:{
                [cell.imageView setImage:[UIImage imageNamed:@"YellowWatchlistButton"]];
                ListsViewController *listsController = (ListsViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                listsController.isFavorites=NO;
                listsController.isWatchlist=YES;
                listsController.isRating=NO;
                [self.navigationController pushViewController:listsController animated:YES];
                [self.sideMenuController showLeftViewAnimated:NO completionHandler:nil];
            }
                break;
            case 3:{
                [cell.imageView setImage:[UIImage imageNamed:@"YellowRatingsButton"]];
                ListsViewController *listsController = (ListsViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                listsController.isFavorites=NO;
                listsController.isWatchlist=NO;
                listsController.isRating=YES;
                [self.navigationController pushViewController:listsController animated:YES];
                [self.sideMenuController showLeftViewAnimated:NO completionHandler:nil];
            }
                break;
            case 5:{
                [cell.imageView setImage:[UIImage imageNamed:@"YellowSettingsButton"]];
                SettingsViewController *settingsView = (SettingsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                [self.navigationController pushViewController:settingsView animated:YES];
                [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
            }
                break;
            case 6:{
                [cell.imageView setImage:[UIImage imageNamed:@"YellowLogoutButton"]];
                
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
//                 .setValue(NSAttributedString(string: messageTitle, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17),NSForegroundColorAttributeName : UIColor.redColor()]), forKey: "attributedTitle")

                
                UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoged"];
                    _isLogged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
                    [self.tableView reloadData];
                }];
                
                UIAlertAction* no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    _selectedIndex=nil;
                }];
                alertController.view.tintColor =[UIColor yellowColor];
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
