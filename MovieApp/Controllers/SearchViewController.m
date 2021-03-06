//
//  SearchViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 06/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import <RestKit/RestKit.h>
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "TVShow.h"
#import "TVMovie.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import <Reachability/Reachability.h>

@interface SearchViewController ()

@property NSString *searchString;
@property NSMutableArray *searchResults;
@property NSMutableArray <TVMovie*> *allResults;
@property Movie *tempMovie;
@property TVShow *tempShow;
@property NSNumber *pageNumber;
@property int setupScroll;
@property BOOL isConnected;
@property UIView *dropDown;
@property UIButton *recconectButton;
@property Reachability *reachability;
@property BOOL notifRec;
@property UIButton *backButton;
@property BOOL isSet;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _searchBar.delegate=self;
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:searchCellIdentifier];
    _isConnected = [ConnectivityTest isConnected];
    [self searchBarSetup];
    [self CreateDropDownList];
    [self setGestures];
    _searchResults = [[NSMutableArray alloc]init];
    _tempMovie=[[Movie alloc]init];
    _tempShow= [[TVShow alloc]init];
    _pageNumber = [NSNumber numberWithInt:1];
    _setupScroll = 0;
    _searchString = @"";
    _notifRec=NO;
    _isSet = NO;
    
    if(!_isConnected){
        [_dropDown setAlpha:1.0];
        [_searchBar setUserInteractionEnabled:NO];
        [self setupBackButton];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
-(void)setupBackButton{
    if(!_isSet){
        CGRect backButRect = CGRectMake(self.view.bounds.size.width-100, 0, 100, 60);
        _backButton =[[UIButton alloc]initWithFrame:backButRect];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton setTitle:@"  " forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
        [_backButton setAlpha:1.0];
        _isSet=YES;
    }
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    
    _reachability = (Reachability *)[notification object];
    if(!_notifRec){
        if ([_reachability isReachable]) {
            NSLog(@"Reachable");
            _isConnected=[ConnectivityTest isConnected];
            if([_dropDown alpha]==1.0){
                [_dropDown setAlpha:0.0];
            }
            [_backButton setAlpha:0.0];
            [_searchBar setUserInteractionEnabled:YES];
            [_searchBar becomeFirstResponder];
            
        } else {
            NSLog(@"Unreachable");
            _isConnected=[ConnectivityTest isConnected];
            [_searchBar setUserInteractionEnabled:NO];
            [_searchBar resignFirstResponder];
            [self setupBackButton];
        }
        _notifRec=YES;
    }
    else{
        _notifRec=NO;
    }
}


-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"Please Reconnect to proceed!"]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, 7)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]
                 range:NSMakeRange(7, 10)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(17, 11)];
    [_recconectButton setAttributedTitle:text forState:UIControlStateNormal];
}

-(void)CreateDropDownList{
    CGRect dropDownFrame =CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64);
    _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
    [_dropDown setBackgroundColor:[UIColor clearColor]];
    CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    _recconectButton = [[UIButton alloc]init];
    _recconectButton.frame = buttonFrame;
    [_recconectButton setBackgroundColor:[UIColor clearColor]];
    _recconectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _recconectButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setButtonTitle];
    [_recconectButton addTarget:self action:@selector(openWifiSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dropDown addSubview:_recconectButton];
    [self.view addSubview:_dropDown];
    [_dropDown setAlpha:0.0];
}

- (IBAction)openWifiSettings:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([ConnectivityTest isConnected])
        [self.searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];   //it hides
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    [self setupSearchbar];
}

-(void)setupSearchbar{
    _searchBar.showsCancelButton = YES;
    for (UIView *subView in _searchBar.subviews) {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)[_searchBar.subviews lastObject];
            [cancelButton setTintColor:[UIColor lightGrayColor]];
            cancelButton=(UIButton*)self.navigationItem.backBarButtonItem;
        }
    }
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    UIColor *backColor = [UIColor colorWithWhite:0.187 alpha:1.0];
    txfSearchField.backgroundColor = backColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES]; // it shows
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchResults != nil ? [_searchResults count] : 0;
    
}

-(void)setGestures{
    UILongPressGestureRecognizer *tapGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)hideKeyboard{
    [self.searchBar resignFirstResponder];
}

-(void)searchBarSetup{
    _searchBar.backgroundColor = [UIColor colorWithRed:42 green:45 blue:44 alpha:100];
    _searchBar.keyboardType=UIKeyboardTypeDefault;
    _searchBar.keyboardAppearance=UIKeyboardAppearanceDark;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    for (UIView *possibleButton in _searchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }
}

-(void)searchForString{
    
    NSString *pathP = @"/3/search/multi";
    if(![_searchString isEqualToString:@""]){
        
        NSDictionary *queryParameters = @{
                                          @"api_key": [ApiKey getApiKey],/*add your api*/
                                          @"query":_searchString
                                          };
        
        [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", mappingResult.array);
            int custIndex=0;
            [_searchResults removeAllObjects];
            _allResults=[[NSMutableArray alloc]initWithArray:mappingResult.array];
            if([_allResults.firstObject isKindOfClass:[TVMovie class]]){
                for (TVMovie *TVorMovie in _allResults) {
                    
                    if (![TVorMovie isMovie]) {
                        TVShow *singleShow= [[TVShow alloc]init];
                        [singleShow setupWithTVMovie:TVorMovie];
                        if(singleShow.showID!=nil && singleShow.name!=nil){
                            [_searchResults insertObject:singleShow atIndex:custIndex];
                            custIndex++;
                        }
                    }
                    else if ([TVorMovie isMovie]) {
                        Movie *singleMovie=[[Movie alloc]init];
                        [singleMovie setupWithTVMovie:TVorMovie];
                        if(singleMovie.movieID!=nil && singleMovie.title!=nil){
                            [_searchResults insertObject:singleMovie atIndex:custIndex];
                            custIndex++;
                        }
                    }
                    
                }
            }
            
            [self reloadContent];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"RestKit returned error: %@", error);
        }];
    }
    
}

-(void)getMoreSearchResults{
    
    NSString *pathP = @"/3/search/multi";
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"query":_searchString,
                                      @"page":_pageNumber
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        int custIndex=[[NSNumber numberWithLong:[_searchResults count]] intValue];
        _allResults=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        for (TVMovie *TVorMovie in _allResults) {
            
            if (![TVorMovie isMovie]) {
                TVShow *singleShow= [[TVShow alloc]init];
                [singleShow setupWithTVMovie:TVorMovie];
                if(singleShow.showID!=nil && singleShow.name!=nil){
                    [_searchResults insertObject:singleShow atIndex:custIndex];
                    custIndex++;
                }
            }
            else if ([TVorMovie isMovie]) {
                Movie *singleMovie=[[Movie alloc]init];
                [singleMovie setupWithTVMovie:TVorMovie];
                if(singleMovie.movieID!=nil && singleMovie.title!=nil){
                    [_searchResults insertObject:singleMovie atIndex:custIndex];
                    custIndex++;
                }
            }
            
        }
        
        [self reloadContent];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}


- (void)reloadContent {
    [self addGradient];
    [self.tableView reloadData];
}

- (void)addGradient {
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.view.bounds;
    gradientMask.colors = @[(id)[UIColor lightGrayColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    gradientMask.locations = @[@0.00, @1.00];
    
    [self.tableView.layer insertSublayer:gradientMask atIndex:0];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    if ([[_searchResults objectAtIndex:indexPath.row] isKindOfClass:[Movie class]]) {
        _tempMovie=[_searchResults objectAtIndex:indexPath.row];
        [cell setSearchCellWithMovie:_tempMovie];
    }
    else if([[_searchResults objectAtIndex:indexPath.row] isKindOfClass:[TVShow class]]){
        _tempShow =[_searchResults objectAtIndex:indexPath.row];
        [cell setSearchCellWithTVShow:_tempShow];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MovieDetailViewController *movieDetails = (MovieDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    if ([[_searchResults objectAtIndex:indexPath.row] isKindOfClass:[Movie class]]) {
        _tempMovie=[_searchResults objectAtIndex:indexPath.row];
        movieDetails.singleMovie = _tempMovie;
        movieDetails.movieID = _tempMovie.movieID;
        movieDetails.isMovie=YES;
    }
    else{
        _tempShow =[_searchResults objectAtIndex:indexPath.row];
        movieDetails.singleShow = _tempShow;
        movieDetails.movieID = _tempShow.showID;
        movieDetails.isMovie=NO;
    }
    [self.navigationController pushViewController:movieDetails animated:NO];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchString=searchText;
    if (_isConnected) {
        [self searchForString];
    }
    else
        //Please reconect to proceed
        _pageNumber=[NSNumber numberWithInt:1];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (550);
    if(_setupScroll>1){
        if (actualPosition >= contentHeight) {
            int i = [_pageNumber intValue];
            _pageNumber = [NSNumber numberWithInt:i+1];
            [self getMoreSearchResults];
        }
    }
    else{
        _setupScroll++;
    }
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
