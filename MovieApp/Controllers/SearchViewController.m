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
#import "MultiObject.h"

@interface SearchViewController ()

@property NSString *searchString;
@property NSMutableArray *searchResults;
@property NSMutableArray <MultiObject*> *allResults;
@property Movie *tempMovie;
@property TVShow *tempShow;

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
    _searchResults = [[NSMutableArray alloc]init];
    _tempMovie=[[Movie alloc]init];
    _tempShow= [[TVShow alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];   //it hides
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    _searchBar.showsCancelButton = YES;
    //Iterate the searchbar sub views
    for (UIView *subView in _searchBar.subviews) {
        //Find the button
        if([subView isKindOfClass:[UIButton class]])
        {
            //Change its properties
            UIButton *cancelButton = (UIButton *)[_searchBar.subviews lastObject];
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

-(void)searchBarSetup{
    _searchBar.backgroundColor = [UIColor colorWithRed:42 green:45 blue:44 alpha:100];
    _searchBar.keyboardType=UIKeyboardTypeDefault;
    _searchBar.keyboardAppearance=UIKeyboardAppearanceDark;
}

-(void)setRestkit{
        NSString *pathP = @"/3/search/multi";
    RKObjectMapping *multiMapping = [RKObjectMapping mappingForClass:[MultiObject class]];
    
    [multiMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"release_date": @"releaseDate",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"id": @"movieID",
                                                       @"backdrop_path" : @"backdropPath",
                                                       @"overview": @"overview",
                                                       @"genre_ids":@"genreIds",
                                                       @"name": @"name",
                                                       @"first_air_date": @"airDate",
                                                       @"id": @"showID",
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
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"query":_searchString
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        int i;
        [_searchResults removeAllObjects];
        _allResults=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        for (i=0; i< [_allResults count]; i++) {
            if ([[_allResults objectAtIndex:i].mediaType isEqualToString:@"tv"]) {
                [_tempShow setupWithMultiObject:[_allResults objectAtIndex:i]];
                [_searchResults addObject:_tempShow];
            }
            else if ([[_allResults objectAtIndex:i].mediaType isEqualToString:@"movie"]) {
                [_tempMovie setupWithMultiObject:[_allResults objectAtIndex:i]];
                [_searchResults addObject:_tempMovie];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    if ([[_searchResults objectAtIndex:indexPath.row] isKindOfClass:[Movie class]]) {
        _tempMovie=[_searchResults objectAtIndex:indexPath.row];
        if(_tempMovie.posterPath!=nil) {
        [cell setSearchCellWithMovie:_tempMovie];
        }
    }
    else if([[_searchResults objectAtIndex:indexPath.row] isKindOfClass:[TVShow class]]){
        _tempShow =[_searchResults objectAtIndex:indexPath.row];
        if(_tempShow.posterPath!=nil){
        [cell setSearchCellWithTVShow:_tempShow];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"MovieOrTVShowDetails" sender:self];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchString=searchText;
    [self searchForString];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MovieOrTVShowDetails"]) {
        MovieDetailViewController *movieDetails = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView.indexPathsForSelectedRows objectAtIndex:0];
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
//        @try {
//            [self.navigationController pushViewController:movieDetails animated:NO];
//        } @catch (NSException * e) {
//            NSLog(@"Exception: %@", e);
//        } @finally {
//            //NSLog(@"finally");
//        }
    }
}


@end
