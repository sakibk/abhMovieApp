//
//  NotificationListViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 28/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "NotificationListViewController.h"
#import "MovieDetailViewController.h"

@interface NotificationListViewController ()

@property NSDictionary *userCredits;
@property RLUserInfo *user;

@end

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:searchCellIdentifier];
    [_tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(_isMovie){
        return _notificationMovies.firstObject !=nil ? [_notificationMovies count] : 0;
    }
    else{
        return _notificationShows.firstObject !=nil ? [_notificationShows count] : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell =(SearchCell*)[tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    cell.isSideBar=YES;
    if(_isMovie){
        [cell setSearchCellWithMovie:[_notificationMovies objectAtIndex:indexPath.row]];
    }
    else{
        [cell setSearchCellWithTVShow:[_notificationShows objectAtIndex:indexPath.row]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setBackgroundColor:[UIColor blackColor]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MovieDetailViewController *movieDetails = [storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    if (_isMovie) {
        Movie *test =[_notificationMovies objectAtIndex:indexPath.row];
        movieDetails.singleMovie = test;
        movieDetails.movieID = test.movieID;
        movieDetails.isMovie=_isMovie;
    }
    else{
        TVShow *tvTest =[_notificationShows objectAtIndex:indexPath.row];
        movieDetails.singleShow = tvTest;
        movieDetails.movieID = tvTest.showID;
        movieDetails.isMovie=_isMovie;
    }
    [self.navigationController pushViewController:movieDetails animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0;
}


-(void)initWithNotificationMovie{
    self.navigationItem.title=@"Premieres";
    [self.tableView reloadData];
}
-(void)initWithNotificationShow{
    self.navigationItem.title=@"Airing Today";
    [self setupUser];
    //todo compare with list watching twshows. if nil, show all.
    [self.tableView reloadData];
}

-(void)setupUser{
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    _user = [users firstObject];
}

-(void)setupView{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
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
