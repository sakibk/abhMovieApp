//
//  MoviesTableViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "MoviesViewController.h"
#import <RestKit/RestKit.h>
#import "Movie.h"
#import "Genre.h"
#import "TVShow.h"
#import "MoviesCell.h"
#import "MovieDetailViewController.h"
#import "SearchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MoviesViewController ()

@property NSMutableArray<Movie *> *allMovies;
@property NSMutableArray<Genre *> *allGenres;
@property NSMutableArray<TVShow *> *allShows;
@property Movie *test;
@property TVShow *tvTest;
@property Genre *singleGenre;
@property NSNumber *pageNumber;
@property NSString *filterString;

@property (nonatomic,strong) UIView *dropDown;
@property (nonatomic,assign) BOOL isDroped;
@property (nonatomic,assign) BOOL isNavBarSet;
@end

@implementation MoviesViewController
{
    CGRect initialCollectionViewFrame;
    UIButton *optionOne;
    UIButton *optionTwo;
    UIButton *optionThree;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    initialCollectionViewFrame = self.collectionView.frame;
    _allMovies=nil;
    _allShows=nil;
    _allGenres=nil;
    _isDroped = NO;
    _isNavBarSet=NO;
    _filterString = @"popularity.desc";
    
    if(_isMovie)
    {
        [self getMovies];
    }
    else{
        [self getShows];
    }
    [self CreateDropDownList];
    
//    self.navigationItem.titleView = self.searchBar;
//    self.navigationItem.leftBarButtonItem =
    [self setNavBar];
  }

-(void)setNavBar{
    if(!_isNavBarSet){
    UIBarButtonItem *pieItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"PieIcon"] style:UIBarButtonItemStylePlain target:identifier action:nil];
    self.navigationItem.leftBarButtonItem=pieItem;
    UITextField *txtSearchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 330, 40)];
        txtSearchField.font = [UIFont systemFontOfSize:15];
        txtSearchField.backgroundColor = [UIColor colorWithRed:42 green:45 blue:44 alpha:100];
        txtSearchField.tintColor= [UIColor colorWithRed:216 green:216 blue:216 alpha:100];
    txtSearchField.textColor= [UIColor colorWithRed:216 green:216 blue:216 alpha:100];
    txtSearchField.textAlignment = UITextAlignmentCenter;
    txtSearchField.placeholder = @"🔍 Search";
    txtSearchField.autocorrectionType = UITextAutocorrectionTypeNo;
    txtSearchField.keyboardType = UIKeyboardTypeDefault;
    txtSearchField.returnKeyType = UIReturnKeyDone;
    txtSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtSearchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtSearchField.delegate = self;
    txtSearchField.borderStyle=UITextBorderStyleRoundedRect;
    self.navigationItem.titleView =txtSearchField;
        _isNavBarSet=YES;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{

    //    MovieDetailViewController *detailController = [[MovieDetailViewController alloc]init];
    //    _test =[_allMovies objectAtIndex:indexPath.row];
    //    [detailController setMovieID:[_test movieID]];
    //     [self.navigationController pushViewController:detailController animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    SearchViewController *searchController = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:searchController animated:YES];
    //SearchViewIdentifier
    [self performSegueWithIdentifier:@"SearchViewIdentifier" sender:self];
    // Here You can do additional code or task instead of writing with keyboard
    return NO;
}


-(void)CreateDropDownList{
        CGRect dropDownFrame =CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64);
        _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
        [_dropDown setBackgroundColor:[UIColor blackColor]];
        CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height);
        UIButton *showList = [[UIButton alloc]init];
        showList.frame = buttonFrame;
        showList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        showList.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [showList setTitle:@"Sorted By" forState:UIControlStateNormal];
        [showList addTarget:self action:@selector(ListDroped:) forControlEvents:UIControlEventTouchUpInside];
        [_dropDown addSubview:showList];
        
        CGRect buttonOneFrame = CGRectMake(0, 64, [_dropDown bounds].size.width, [_dropDown bounds].size.height/4);
        optionOne = [[UIButton alloc]init];
        optionOne.frame=buttonOneFrame;
        [optionOne setTitle:@"Most Popular" forState:UIControlStateNormal];
        [optionOne addTarget:self action:@selector(OptionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionOne.tag=0;
        [_dropDown addSubview:optionOne];
        
        CGRect buttonTwoFrame = CGRectMake(0, 64*2, [_dropDown bounds].size.width, [_dropDown bounds].size.height/4);
        optionTwo = [[UIButton alloc]init];
        optionTwo.frame=buttonTwoFrame;
        [optionTwo setTitle:@"Latest" forState:UIControlStateNormal];
        [optionTwo addTarget:self action:@selector(OptionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionTwo.tag=1;
        [_dropDown addSubview:optionTwo];
        
        CGRect buttonThreeFrame = CGRectMake(0, 64*3, [_dropDown bounds].size.width, [_dropDown bounds].size.height/4);
        optionThree = [[UIButton alloc]init];
        optionThree.frame=buttonThreeFrame;
        [optionThree setTitle:@"Highest Rated" forState:UIControlStateNormal];
        [optionThree addTarget:self action:@selector(OptionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionThree.tag=2;
        [_dropDown addSubview:optionThree];
        
        [optionOne setAlpha:0.0];
        [optionTwo setAlpha:0.0];
        [optionThree setAlpha:0.0];
        [self.view insertSubview:_dropDown aboveSubview:_collectionView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dropDown attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dropDown attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

-(IBAction)ListDroped:(id)sender{
    if(!_isDroped){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y + 192, CGRectGetWidth(initialCollectionViewFrame), CGRectGetHeight(initialCollectionViewFrame));
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect openedListFrame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64*4);
                [_dropDown setFrame:openedListFrame];
                _isDroped = YES;
                [optionOne setAlpha:1.0];
                [optionTwo setAlpha:1.0];
                [optionThree setAlpha:1.0];
            }];
        }];
    } else{
        [UIView animateWithDuration:0.05 animations:^{
            [optionOne setAlpha:0.0];
            [optionTwo setAlpha:0.0];
            [optionThree setAlpha:0.0];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.2 animations:^{
              CGRect dropDownFrame =CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 64);
              [_dropDown setFrame:dropDownFrame];
              self.collectionView.frame = initialCollectionViewFrame;
              _isDroped = NO;
          }];
        }];
    }
}

-(IBAction)OptionPressed:(UIButton*)sender{
    
    if(sender.tag==0){
        _filterString =@"popularity.desc";
        
    }
    else if(sender.tag==1){
        _filterString =@"release_date.desc";
        
    }
    else if(sender.tag==2){
        _filterString =@"vote_average.desc";
        
    }
    if(_isMovie)
    {
        [self getMovies];
    }
    else{
        [self getShows];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getMovies{
    NSString *localFilterString = _filterString;
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    
    [movieMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"release_date": @"releaseDate",
                                                       @"id": @"movieID",
                                                       @"backdrop_path" : @"backdropPath",
                                                       @"genre_ids":@"genreIds"
                                                       }];
    NSString *pathP =@"/3/discover/movie";
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    //    [RKMIMETypeSerialization registerClass:[RKURLEncodedSerialization class] forMIMEType:@"text/html"];
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        if(_allMovies!=nil){
            _allMovies=nil;
            _allMovies=[[NSMutableArray alloc]init];
            for(Movie *m in mappingResult.array){
                if(m.backdropPath!=nil && m.posterPath!=nil && m.releaseDate!=nil){
                    [_allMovies addObject:m];
                }
            }
            [self setPageNumber:[NSNumber numberWithInt:1]];
            [_collectionView reloadData];
        }
        else{
            _allMovies=[[NSMutableArray alloc]initWithArray:mappingResult.array];
            [self setPageNumber:[NSNumber numberWithInt:1]];
            [_collectionView reloadData];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    if(_allGenres==nil) {
        [self getMovieGenres];
    }
}

-(void)getMoreMovies{
    NSString *localFilterString = _filterString;
    int currentPage = [_pageNumber intValue];
    _pageNumber = [NSNumber numberWithInt:currentPage+1];
    NSString *pathP =@"/3/discover/movie";
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"page":_pageNumber
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        for(Movie *m in mappingResult.array){
            if(m.backdropPath!=nil && m.posterPath!=nil && m.releaseDate!=nil){
                [_allMovies addObject:m];
            }
        }

        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];

}


- (void)getMovieGenres
{
    
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
    
    [genreMapping addAttributeMappingsFromDictionary:@{@"id": @"genreID",
                                                       @"name": @"genreName"
                                                       }];

        NSString *pathP =@"/3/genre/movie/list";
    
    RKResponseDescriptor *responseGenreDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:genreMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"genres"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseGenreDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allGenres=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    

}

-(void)getShows{
    
    NSString *localFilterString = _filterString;
    
    RKObjectMapping *showMapping = [RKObjectMapping mappingForClass:[TVShow class]];
    
    [showMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                      @"vote_average": @"rating",
                                                      @"poster_path": @"posterPath",
                                                      @"first_air_date": @"airDate",
                                                      @"id": @"showID",
                                                      @"backdrop_path" : @"backdropPath",
                                                      @"overview": @"overview",
                                                      @"genre_ids": @"genreIds",
                                                      @"number_of_seasons":@"seasonCount"
                                                      }];
    
    NSString *pathP =@"/3/discover/tv";
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:showMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    //    [RKMIMETypeSerialization registerClass:[RKURLEncodedSerialization class] forMIMEType:@"text/html"];
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64" /*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        if(_allShows!=nil){
            _allShows=nil;
            _allShows =[[NSMutableArray alloc]init];
            for(TVShow *tv in mappingResult.array){
                if(tv.posterPath!=nil && tv.backdropPath!=nil && tv.airDate!=nil){
                    [_allShows addObject:tv];
                }
            }
            [self.collectionView reloadData];
            [self setPageNumber:[NSNumber numberWithInt:1]];
        }
        else{
            _allShows =[[NSMutableArray alloc]initWithArray:mappingResult.array];
            [self.collectionView reloadData];
            [self setPageNumber:[NSNumber numberWithInt:1]];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    if(_allGenres==nil){
        [self getTVGenres];
    }
}

-(void)getMoreShows{
    
    NSString *localFilterString = _filterString;
    
    int currentPage = [_pageNumber intValue];
    _pageNumber = [NSNumber numberWithInt:currentPage+1];
    
    NSString *pathP =@"/3/discover/tv";
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64", /*add your api*/
                                      @"page":_pageNumber
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        for(TVShow *tv in mappingResult.array){
            if(tv.posterPath!=nil && tv.backdropPath!=nil && tv.airDate!=nil){
                [_allShows addObject:tv];
            }
        }
        [self.collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

- (void)getTVGenres
{
    
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
    
    [genreMapping addAttributeMappingsFromDictionary:@{@"id": @"genreID",
                                                       @"name": @"genreName"
                                                       }];
    
    NSString *pathP =@"/3/genre/tv/list";
    
    RKResponseDescriptor *responseGenreDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:genreMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"genres"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseGenreDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allGenres=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isMovie) {
        return [_allMovies count];
    }
    else{
        return [_allShows count];
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(199, 254);
//}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(self.view.bounds) - 25) / 2;
    return CGSizeMake(width, width / 0.69);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    MovieDetailViewController *detailController = [[MovieDetailViewController alloc]init];
//    _test =[_allMovies objectAtIndex:indexPath.row];
//    [detailController setMovieID:[_test movieID]];
//     [self.navigationController pushViewController:detailController animated:YES];
    
    [self performSegueWithIdentifier:@"MovieOrTVShowDetails" sender:self];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MoviesCell *cell = (MoviesCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_isMovie) {
        _test =[_allMovies objectAtIndex:indexPath.row];
        _test.genres=[[NSMutableArray alloc]initWithArray:_allGenres];
        [cell setupMovieCell:_test];
    }
    else {
        _tvTest =[_allShows objectAtIndex:indexPath.row];
        _tvTest.genres=[[NSMutableArray alloc]initWithArray:_allGenres];
        [cell setupShowCell:_tvTest];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (600);
    if (actualPosition >= contentHeight) {
        if(_isMovie){
            [self getMoreMovies];
        }
        else{
            [self getMoreShows];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MovieOrTVShowDetails"]) {
        MovieDetailViewController *movieDetails = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        if (_isMovie) {
        _test =[_allMovies objectAtIndex:indexPath.row];
        movieDetails.singleMovie = _test;
        movieDetails.movieID = _test.movieID;
            movieDetails.isMovie=_isMovie;
        }
        else{
            _tvTest =[_allShows objectAtIndex:indexPath.row];
            movieDetails.singleShow = _tvTest;
            movieDetails.movieID = _tvTest.showID;
            movieDetails.isMovie=_isMovie;
        }
    }
    else if ([segue.identifier isEqualToString:@"SearchViewIdentifier"]){
        SearchViewController *searchView = segue.destinationViewController;
    }
}


@end
