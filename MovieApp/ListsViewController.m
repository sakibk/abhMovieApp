//
//  ListsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ListsViewController.h"
#import "SearchCell.h"
#import "RLUserInfo.h"
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "TVShow.h"
#import <RestKit/RestKit.h>
#import "PostResponse.h"
#import "ListPost.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"

@interface ListsViewController ()
@property NSString *dropDownTitle;
@property int selectedButton;

@property (nonatomic,strong) UIView *dropDown;
@property (nonatomic,assign) BOOL isDroped;
@property (nonatomic,assign) BOOL isNavBarSet;
@property BOOL isSuccessful;

@property NSDictionary *userCredits;
@property RLUserInfo *user;
@property RLMRealm *realm;
@property BOOL isConnected;

@property (strong,nonatomic) NSString *pathK;

@end

@implementation ListsViewController
{
    CGRect initialTableViewFrame;
    UIButton *showList;
    UIButton *optionOne;
    UIButton *optionTwo;
    UIImageView *imageOne;
    UIImageView *imageTwo;
    UIImageView *dropDownImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate=self;
    _tableView.dataSource= self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:searchCellIdentifier];
    initialTableViewFrame = self.tableView.frame;
    [self setupUser];
    [self setupView];
    [self setupVariables];
    [self CreateDropDownList];
    [self setupTableviewData];
}

-(void)setupTableviewData{
    if(_isWatchlist && !_isFavorites && !_isRating){
        _movieList=[_user watchlistMovies];
        _showsList=[_user watchlistShows];
        _noListLabel.text=@"No Watchlist";
        self.navigationItem.title =@"Watchlist";
    }
    else if(_isFavorites && !_isWatchlist &&  !_isRating){
        _movieList=[_user favoriteMovies];
        _showsList=[_user favoriteShows];
        _noListLabel.text=@"No Favorites";
        self.navigationItem.title =@"Favorites";
    }
    else if(_isRating  && !_isFavorites && !_isWatchlist){
        _movieList=[_user ratedMovies];
        _showsList=[_user ratedShows];
        _noListLabel.text=@"No Rated";
        self.navigationItem.title =@"Ratings";
    }
    if(_isMovie){
        if(_movieList.firstObject!=nil){
            [_noListLabel setAlpha:0.0];
            [_noListImage setAlpha:0.0];
        }
        else{
            [_noListLabel setAlpha:1.0];
            [_noListImage setAlpha:1.0];
        }
    }
    else{
        if(_showsList.firstObject!=nil){
            [_noListLabel setAlpha:0.0];
            [_noListImage setAlpha:0.0];
        }
        else{
            [_noListLabel setAlpha:1.0];
            [_noListImage setAlpha:1.0];
        }
    }
    [self.tableView reloadData];
}

-(void)setupUser{
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    _user = [users firstObject];
    _realm=[RLMRealm defaultRealm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)setupVariables{
    _movieList=nil;
    _showsList=nil;
    _isDroped = NO;
    _isNavBarSet=NO;
    _dropDownTitle=@"Movies";
    _selectedButton = 0;
    _isMovie=YES;
    _isConnected=[ConnectivityTest isConnected];
}

-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@" Filter by: %@",_dropDownTitle]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, 11)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor lightGrayColor]
                 range:NSMakeRange(11, [text length]-11)];
    [showList setAttributedTitle:text forState:UIControlStateNormal];
}

-(void)CreateDropDownList{
    CGRect imageFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2+[[UIScreen mainScreen] bounds].size.width/8, 27 , 20 , 10);
    dropDownImage =[[UIImageView alloc] initWithFrame:imageFrame];
    [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
    CGRect dropDownFrame =CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64);
    _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
    [_dropDown setBackgroundColor:[UIColor darkGrayColor]];
    CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    showList = [[UIButton alloc]init];
    showList.frame = buttonFrame;
    [showList setBackgroundColor:[UIColor blackColor]];
    showList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    showList.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setButtonTitle];
    [showList addTarget:self action:@selector(ListDroped:) forControlEvents:UIControlEventTouchUpInside];
    [_dropDown addSubview:showList];
    [_dropDown addSubview:dropDownImage];
    
    CGRect pictureOneFrame = CGRectMake(22, 64+24 , 20, 15);
    imageOne = [[UIImageView alloc]initWithFrame:pictureOneFrame];
    [imageOne setImage:[UIImage imageNamed:@"DropDownSelected"]];
    CGRect buttonOneFrame = CGRectMake(0, 64, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionOne = [[UIButton alloc]init];
    optionOne.frame=buttonOneFrame;
    optionOne.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionOne setBackgroundColor:[UIColor blackColor]];
    [optionOne setTitle:@"Movies" forState:UIControlStateNormal];
    optionOne.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionOne addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionOne.tag=0;
    [_dropDown addSubview:optionOne];
    [_dropDown addSubview:imageOne];
    
    CGRect pictureTwoFrame = CGRectMake(22, 64*2+24 , 20, 15);
    imageTwo = [[UIImageView alloc]initWithFrame:pictureTwoFrame];
    [imageTwo setImage:[UIImage imageNamed:@""]];
    CGRect buttonTwoFrame = CGRectMake(0, 64*2, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionTwo = [[UIButton alloc]init];
    optionTwo.frame=buttonTwoFrame;
    optionTwo.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionTwo setBackgroundColor:[UIColor blackColor]];
    [optionTwo setTitle:@"TV Shows" forState:UIControlStateNormal];
    optionTwo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionTwo addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionTwo.tag=1;
    [_dropDown addSubview:optionTwo];
    [_dropDown addSubview:imageTwo];
    
    [optionOne setAlpha:0.0];
    [optionTwo setAlpha:0.0];
    [imageOne setAlpha:0.0];
    [imageTwo setAlpha:0.0];
    [self.view insertSubview:_dropDown aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dropDown attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}


-(IBAction)ListDroped:(id)sender{
    if(!_isDroped){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y + 192, CGRectGetWidth(initialTableViewFrame), CGRectGetHeight(initialTableViewFrame));
            [self setButtonTitle];
            [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect openedListFrame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64*3);
                [_dropDown setFrame:openedListFrame];
                _isDroped = YES;
                [imageOne setAlpha:1.0];
                [imageTwo setAlpha:1.0];
                [optionOne setAlpha:1.0];
                [optionTwo setAlpha:1.0];
            }];
        }];
    } else{
        [UIView animateWithDuration:0.05 animations:^{
            [optionOne setAlpha:0.0];
            [optionTwo setAlpha:0.0];
            [imageOne setAlpha:0.0];
            [imageTwo setAlpha:0.0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect dropDownFrame =CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64);
                [_dropDown setFrame:dropDownFrame];
                [self setButtonTitle];
                [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
                
                self.tableView.frame = initialTableViewFrame;
                _isDroped = NO;
            }];
        }];
    }
}

-(void)setDropDownTitleButton{
    if(_isDroped){
        [self setButtonTitle];
        [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        
    }
    else{
        [self setButtonTitle];
        [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
        
    }
}

-(IBAction)optionPressed:(UIButton*)sender{
    
    if(sender.tag==0){
        _isMovie=YES;
        [self setDropDownTitleButton];
        _selectedButton=0;
        _dropDownTitle=@"Movies";
    }
    else if(sender.tag==1){
        _isMovie=NO;
        [self setDropDownTitleButton];
        _selectedButton=1;
        _dropDownTitle=@"TV Shows";
    }
    [self ListDroped:sender];
    [self setupButtons];
    [self.tableView reloadData];
}

-(void)setupButtons{
    NSString *selectedButton =@"DropDownSelected";
    NSString *notSelectedButton=@"";
    NSString *buttonOne;
    NSString *buttonTwo;
    
    if(_selectedButton ==0){
        buttonOne=selectedButton;
        buttonTwo=notSelectedButton;
    }
    else if(_selectedButton ==1){
        buttonOne=notSelectedButton;
        buttonTwo=selectedButton;
    }
    [imageOne setImage:[UIImage imageNamed:buttonOne]];
    [imageTwo setImage:[UIImage imageNamed:buttonTwo]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isMovie){
        if(_movieList.firstObject!=nil){
            [_noListLabel setAlpha:0.0];
            [_noListImage setAlpha:0.0];
            return [_movieList count];
        }
        else{
            [_noListLabel setAlpha:1.0];
            [_noListImage setAlpha:1.0];
            return 0;
        }
    }
    else{
        if(_showsList.firstObject!=nil){
            [_noListLabel setAlpha:0.0];
            [_noListImage setAlpha:0.0];
            return [_showsList count];
        }
        else{
            [_noListLabel setAlpha:1.0];
            [_noListImage setAlpha:1.0];
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell =(SearchCell*)[tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    cell.isSideBar=YES;
    if(_isMovie){
        [cell setSearchCellWithMovie:[[Movie alloc]initWithObject:[_movieList objectAtIndex:indexPath.row]]];
    }
    else{
        [cell setSearchCellWithTVShow:[[TVShow alloc]initWithObject:[_showsList objectAtIndex:indexPath.row]]];
    }
    [cell.searchRating setTextColor:[UIColor lightGrayColor]];
    [cell.releaseAirDate setTextColor:[UIColor lightGrayColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setBackgroundColor:[UIColor blackColor]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MovieDetailViewController *movieDetails = [storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    if (_isMovie) {
        Movie *test =[[Movie alloc] initWithObject:[_movieList objectAtIndex:indexPath.row]];
        movieDetails.singleMovie = test;
        movieDetails.movieID = test.movieID;
        movieDetails.isMovie=_isMovie;
    }
    else{
        TVShow *tvTest =[[TVShow alloc]initWithObject:[_showsList objectAtIndex:indexPath.row]];
        movieDetails.singleShow = tvTest;
        movieDetails.movieID = tvTest.showID;
        movieDetails.isMovie=_isMovie;
    }
    [self.navigationController pushViewController:movieDetails animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    _isConnected = [ConnectivityTest isConnected];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Remove"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        ReconnectedList* rl = [[ReconnectedList alloc] init];
        rl.isMovie = _isMovie;
        rl.toSet=NO;
        if(_isMovie){
            rl.mediaID= [[_movieList objectAtIndex:indexPath.row] movieID];
            if(_isFavorites){
                if(_isConnected)
                    [self noRestkitPost:@"favorite": @"movie" :[_movieList objectAtIndex:indexPath.row].movieID];
                else
                    rl.listName = @"favorite";
                [_user deleteFavoriteMovies:[_movieList objectAtIndex:indexPath.row]];
            }
            else if(_isWatchlist){
                if(_isConnected)
                    [self noRestkitPost:@"watchlist": @"movie" :[_movieList objectAtIndex:indexPath.row].movieID];
                else
                    rl.listName=@"watchlist";
                [_user deleteWatchlistMovies:[_movieList objectAtIndex:indexPath.row]];
            }
            else if (_isRating){
                if(_isConnected)
                    [self noRestkitDeleteRate:[_movieList objectAtIndex:indexPath.row].movieID];
                else
                    rl.listName=@"rating";
                [_user deleteRatedMovies:[_movieList objectAtIndex:indexPath.row]];
            }
        }
        else{
            rl.mediaID =[[_showsList objectAtIndex:indexPath.row] showID];
            if(_isFavorites){
                if(_isConnected)
                    [self noRestkitPost:@"favorite": @"tv" :[_showsList objectAtIndex:indexPath.row].showID];
                else
                    rl.listName=@"favorite";
                [_user deleteFavoriteShows:[_showsList objectAtIndex:indexPath.row]];
            }
            else if(_isWatchlist){
                if(_isConnected)
                    [self noRestkitPost:@"watchlist": @"tv" :[_showsList objectAtIndex:indexPath.row].showID];
                else
                    rl.listName=@"watchlist";
                [_user deleteWatchlistShows:[_showsList objectAtIndex:indexPath.row]];
            }
            else if (_isRating){
                if(_isConnected)
                    [self noRestkitDeleteRate:[_showsList objectAtIndex:indexPath.row].showID];
                else
                    rl.listName=@"rating";
                [_user deleteRatedShows:[_showsList objectAtIndex:indexPath.row]];
            }
        }
        if(_isConnected){
            [_realm beginWriteTransaction];
            RLReconectedList * rlr = [[RLReconectedList alloc] initWithRL:rl];
            [_realm addObject:rlr];
            [_realm commitWriteTransaction];
        }
        [self.tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0];
    
    UIFont *font = [UIFont systemFontOfSize:19];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString: @"Remove"
                                                                          attributes: attributes];
    [[UIButton appearanceWhenContainedIn:[UIView class], [SearchCell class], nil] setAttributedTitle: attributedTitle
                                                                                            forState: UIControlStateNormal];
    return @[deleteAction];
}

+ (void)setUpDeleteRowActionStyleForUserCell {
    
    UIFont *font = [UIFont systemFontOfSize:19];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString: @"Remove"
                                                                          attributes: attributes];
    
    /*
     * We include UIView in the containment hierarchy because there is another button in UserCell that is a direct descendant of UserCell that we don't want this to affect.
     */
    [[UIButton appearanceWhenContainedIn:[UIView class], [SearchCell class], nil] setAttributedTitle: attributedTitle
                                                                                            forState: UIControlStateNormal];
}


-(void)noRestkitPost:(NSString*)list :(NSString *)mediaType :(NSNumber *)mediaID{
    NSError *error;
    
    NSString *pathP = [NSString stringWithFormat:@"https://api.themoviedb.org/3/account/%@/%@?api_key=%@&session_id=%@",[_userCredits objectForKey:@"userID"],list,[ApiKey getApiKey],[_userCredits objectForKey:@"sessionID"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{
                                            @"Content-Type" : @"application/json;charset=utf-8"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:pathP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    
    NSDictionary *dataMapped = @{@"media_type" : mediaType,
                                 @"media_id" : mediaID,
                                 [NSString stringWithFormat:@"%@",list] : @NO
                                 };
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataMapped options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error){
            if([[dictionary valueForKey:@"status_code"] intValue]==13){
                NSLog(@"The item/record was Deleted successfully");
                _isSuccessful=YES;
            }
            else if([[dictionary valueForKey:@"status_code"] intValue]==12){
                NSLog(@"The item/record was updated successfully");
                _isSuccessful=NO;
            }
        }
        else{
            _isSuccessful=NO;
        }
    }];
    
    [postDataTask resume];
}



-(void)noRestkitDeleteRate:(NSNumber*) mediaID{
    
    if(_isMovie){
        _pathK = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/rating?api_key=%@&session_id=%@",mediaID, [ApiKey getApiKey], [_userCredits objectForKey:@"sessionID"]];
    }
    else{
        _pathK = [NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%@/rating?api_key=%@&session_id=%@",mediaID, [ApiKey getApiKey], [_userCredits objectForKey:@"sessionID"]];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{
                                            @"Content-Type" : @"application/json;charset=utf-8"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:_pathK];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSData *postData = [[NSData alloc] initWithData:[@"{}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error){
            if([[dictionary valueForKey:@"status_code"] intValue]==13){
                NSLog(@"Rating deleted");
            }
            else if([[dictionary valueForKey:@"status_code"] intValue]==12){
                NSLog(@"The item/record was updated successfully");
            }
        }
        else{
        }
    }];
    
    [postDataTask resume];
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 //    if ([segue.identifier isEqualToString:@"MovieOrTVShowDetails"]) {
 //        MovieDetailViewController *movieDetails = segue.destinationViewController;
 //        NSIndexPath *indexPath = [self.tableView.indexPathsForSelectedRows objectAtIndex:0];
 //        }
 }
 */

@end
