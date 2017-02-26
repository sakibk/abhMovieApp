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

@interface ListsViewController ()
@property NSString *dropDownTitle;
@property int selectedButton;

@property (nonatomic,strong) UIView *dropDown;
@property (nonatomic,assign) BOOL isDroped;
@property (nonatomic,assign) BOOL isNavBarSet;

@property NSDictionary *userCredits;
@property RLUserInfo *user;
@property RLMRealm *realm;

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
}

-(void)CreateDropDownList{
    CGRect imageFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-[[UIScreen mainScreen] bounds].size.width/32, 23 , 20 , 15);
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
    [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
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
            [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
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
                [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
                [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
                
                self.tableView.frame = initialTableViewFrame;
                _isDroped = NO;
            }];
        }];
    }
}

-(void)setDropDownTitleButton{
    if(_isDroped){
        [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
        [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        
    }
    else{
        [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
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
    if(_isMovie)
    {
//        [self getMovies];
    }
    else if(!_isMovie){
//        [self getShows];
    }
    else{
        
    }
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
    if(_isMovie){
        [cell setSearchCellWithMovie:[[Movie alloc]initWithObject:[_movieList objectAtIndex:indexPath.row]]];
    }
    else{
        [cell setSearchCellWithTVShow:[[TVShow alloc]initWithObject:[_showsList objectAtIndex:indexPath.row]]];
    }
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
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        if(_isMovie){
            if(_isFavorites){
                [self deleteFromList:@"favorite": @"movie" :[_movieList objectAtIndex:indexPath.row].movieID];
                [_user deleteFavoriteMovies:[_movieList objectAtIndex:indexPath.row]];
            }
            else if(_isWatchlist){
                [self deleteFromList:@"watchlist": @"movie" :[_movieList objectAtIndex:indexPath.row].movieID];
                [_user deleteWatchlistMovies:[_movieList objectAtIndex:indexPath.row]];
            }
            else if (_isRating){
                [_user deleteRatedMovies:[_movieList objectAtIndex:indexPath.row]];
            }
        }
        else{
            if(_isFavorites){
                [self deleteFromList:@"favorite": @"tv" :[_showsList objectAtIndex:indexPath.row].showID];
                [_user deleteFavoriteShows:[_showsList objectAtIndex:indexPath.row]];
            }
            else if(_isWatchlist){
                [self deleteFromList:@"watchlist": @"tv" :[_showsList objectAtIndex:indexPath.row].showID];
                [_user deleteWatchlistShows:[_showsList objectAtIndex:indexPath.row]];
            }
            else if (_isRating){
                [_user deleteRatedShows:[_showsList objectAtIndex:indexPath.row]];
            }
        }
        [self.tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor yellowColor];
    
    UIFont *font = [UIFont systemFontOfSize:19];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString: @"Delete"
                                                                          attributes: attributes];
    [[UIButton appearanceWhenContainedIn:[UIView class], [SearchCell class], nil] setAttributedTitle: attributedTitle
                                                                                            forState: UIControlStateNormal];
    return @[deleteAction];
}

+ (void)setUpDeleteRowActionStyleForUserCell {
    
    UIFont *font = [UIFont systemFontOfSize:19];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString: @"Delete"
                                                                          attributes: attributes];
    
    /*
     * We include UIView in the containment hierarchy because there is another button in UserCell that is a direct descendant of UserCell that we don't want this to affect.
     */
    [[UIButton appearanceWhenContainedIn:[UIView class], [SearchCell class], nil] setAttributedTitle: attributedTitle
                                                                                          forState: UIControlStateNormal];
}

-(void)deleteFromList:(NSString *)listName :(NSString *)mediaType :(NSNumber *)mediaID{
        NSString *pathP = [NSString stringWithFormat:@"/3/account/%@/%@?api_key=%@&session_id=%@",[_userCredits objectForKey:@"userID"],listName,@"893050c58b2e2dfe6fa9f3fae12eaf64",[_userCredits objectForKey:@"sessionID"]];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[PostResponse class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"status_code":@"statusCode",
                                                          @"status_message":@"statusMessage"
                                                          }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *postDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:pathP keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromDictionary:@{@"status_code":@"statusCode",
                                                         @"status_message":@"statusMessage"
                                                         }];
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[PostResponse class] rootKeyPath:nil method:RKRequestMethodPOST];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:@"application/json"];
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:postDescriptor];
    
    ListPost *lp = [ListPost new];
    lp.mediaID=mediaID;
    lp.mediaType=mediaType;
    lp.isWatchlist=@"false";
    
    NSDictionary *dict =@{@"media_type":mediaType,
                          @"media_id":mediaID,
                          listName:@"false"};
    
    // POST to create
    [[RKObjectManager sharedManager] postObject:nil path:pathP parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        PostResponse *pr=mappingResult.array.firstObject;
        NSLog(@"status message: %@, status code %@",pr.statusMessage,pr.statusCode);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
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
