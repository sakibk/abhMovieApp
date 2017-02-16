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

@interface SearchViewController ()

@property NSString *searchString;
@property NSMutableArray *searchResults;
@property NSMutableArray <TVMovie*> *allResults;
@property Movie *tempMovie;
@property TVShow *tempShow;
@property NSNumber *pageNumber;
@property int setupScroll;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _searchBar.delegate=self;
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:searchCellIdentifier];
    [self searchBarSetup];
    [self setRestkit];
    [self setGestures];
    _searchResults = [[NSMutableArray alloc]init];
    _tempMovie=[[Movie alloc]init];
    _tempShow= [[TVShow alloc]init];
    _pageNumber = [NSNumber numberWithInt:1];
    _setupScroll = 0;
    _searchString = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];   //it hides
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    _searchBar.showsCancelButton = YES;
    for (UIView *subView in _searchBar.subviews) {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)[_searchBar.subviews lastObject];
            [cancelButton setTintColor:[UIColor lightGrayColor]];
            cancelButton=(UIButton*)self.navigationItem.backBarButtonItem;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES]; // it shows
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchResults != nil ? [_searchResults count] : 0;

}

-(void)setGestures{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
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
}

-(void)setRestkit{
        NSString *pathP = @"/3/search/multi";
    RKObjectMapping *multiMapping = [RKObjectMapping mappingForClass:[TVMovie class]];
    
    [multiMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"release_date": @"releaseDate",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"id": @"TVMovieID",
                                                       @"backdrop_path" : @"backdropPath",
                                                       @"overview": @"overview",
                                                       @"genre_ids":@"genreIds",
                                                       @"name": @"name",
                                                       @"first_air_date": @"airDate",
                                                       @"media_type":@"mediaType"
                                                       }];
    
    RKResponseDescriptor *multiResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:multiMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:multiResponseDescriptor];

}

-(void)searchForString{

    NSString *pathP = @"/3/search/multi";
    if(![_searchString isEqualToString:@""]){
        
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"query":_searchString
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        int custIndex=0;
        [_searchResults removeAllObjects];
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
    
}

-(void)getMoreSearchResults{
    
    NSString *pathP = @"/3/search/multi";
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
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
    [self searchForString];
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
