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

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

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
        
        [self.tableView setScrollEnabled:NO];
        
        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 124.0, 0.0);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [headerView setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [headerView setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [headerView setHidden:YES];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    cell.separatorView.hidden = (indexPath.row >=2 || indexPath.row<1);
        [cell setBackgroundColor:[UIColor blackColor]];
    if (indexPath.row==2) {
        [cell.imageView setImage:[UIImage imageNamed:@"LoginArrow"]];
        [cell.imageView sizeToFit];
        [cell setUserInteractionEnabled:YES];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height/16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==2){
        NSLog(@"tapped");
        
        LeftViewCell *cell = (LeftViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell setBackgroundColor:[UIColor darkGrayColor]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:248.0 green:202.0 blue:0 alpha:100.0]];
        [cell.imageView setImage:[UIImage imageNamed:@"YellowLoginArrow"]];
        _selectedIndex=indexPath;
//        [self performSegueWithIdentifier:@"loginViewIdentifier" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *loginController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
                [self.navigationController pushViewController:loginController animated:YES];

        //

    }
   }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginControllerIdentifier"]){
        LoginViewController *login = segue.destinationViewController;
    }
    }



@end
