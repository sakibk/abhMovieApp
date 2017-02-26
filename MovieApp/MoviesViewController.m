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
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LeftViewController.h"
#import "RLUserInfo.h"
RLM_ARRAY_TYPE(Movie);

@interface MoviesViewController ()

@property NSMutableArray<Movie *> *allMovies;
@property NSMutableArray<Genre *> *allGenres;
@property NSMutableArray<TVShow *> *allShows;
@property Movie *test;
@property TVShow *tvTest;
@property Genre *singleGenre;
@property NSNumber *pageNumber;
@property NSString *filterString;
@property NSString *dropDownTitle;
@property int selectedButton;

@property NSDictionary *userCredits;
@property BOOL isLoged;
@property RLUserInfo *user;

@property RLMRealm *realm;

@property (nonatomic,strong) UIView *dropDown;
@property (nonatomic,assign) BOOL isDroped;
@property (nonatomic,assign) BOOL isNavBarSet;
@end

@implementation MoviesViewController
{
    CGRect initialCollectionViewFrame;
    UIButton *showList;
    UIButton *optionOne;
    UIButton *optionTwo;
    UIButton *optionThree;
    UIImageView *imageOne;
    UIImageView *imageTwo;
    UIImageView *imageThree;
    UIImageView *dropDownImage;
    UIViewController *rootViewController;
    UITableViewController *leftViewController;
    UITableViewController *rightViewController;
    LGSideMenuController *sideMenuController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    initialCollectionViewFrame = self.collectionView.frame;
    _isLoged = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(_isLoged){
        _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
        RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
        _user = [users firstObject];
    }
    _realm=[RLMRealm defaultRealm];
    [self setupVariables];
    if(_isMovie)
    {
        [self getMovies];
    }
    else{
        [self getShows];
    }
    [self CreateDropDownList];
    [self setNavBar];  }


- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)setupVariables{
    _allMovies=nil;
    _allShows=nil;
    _allGenres=nil;
    _isDroped = NO;
    _isNavBarSet=NO;
    _filterString = @"popularity.desc";
    _dropDownTitle=@"Most popular";
    _selectedButton = 0;
}

-(void)setNavBar{
    if(!_isNavBarSet){
        UIBarButtonItem *pieItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"PieIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSideBar:)];
    self.navigationItem.leftBarButtonItem=pieItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UITextField *txtSearchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 330, 27)];
        txtSearchField.font = [UIFont systemFontOfSize:15];
        txtSearchField.backgroundColor = [UIColor darkGrayColor];
        txtSearchField.tintColor= [UIColor colorWithRed:42 green:45 blue:44 alpha:100];
    txtSearchField.textColor= [UIColor colorWithRed:216 green:216 blue:216 alpha:100];
    txtSearchField.textAlignment = NSTextAlignmentCenter;
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

-(IBAction)pushSideBar:(id)sender{
     [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //SearchViewIdentifier
    [self performSegueWithIdentifier:@"SearchViewIdentifier" sender:self];
    return NO;
}


-(void)CreateDropDownList{
        CGRect imageFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2+[[UIScreen mainScreen] bounds].size.width/16, 23 , 20 , 15);
    dropDownImage =[[UIImageView alloc] initWithFrame:imageFrame];
    [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
        CGRect dropDownFrame =CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64);
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
        [optionOne setTitle:@"Most Popular" forState:UIControlStateNormal];
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
        [optionTwo setTitle:@"Latest" forState:UIControlStateNormal];
        optionTwo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [optionTwo addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionTwo.tag=1;
    [_dropDown addSubview:optionTwo];
    [_dropDown addSubview:imageTwo];
    
    
    CGRect pictureThreeFrame = CGRectMake(22, 64*3+24 , 20, 15);
    imageThree = [[UIImageView alloc]initWithFrame:pictureThreeFrame];
    [imageThree setImage:[UIImage imageNamed:@""]];
        CGRect buttonThreeFrame = CGRectMake(0, 64*3, [_dropDown bounds].size.width, [_dropDown bounds].size.height);
        optionThree = [[UIButton alloc]init];
        optionThree.frame=buttonThreeFrame;
        optionThree.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionThree setBackgroundColor:[UIColor blackColor]];
        [optionThree setTitle:@"Highest Rated" forState:UIControlStateNormal];
        optionThree.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [optionThree addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionThree.tag=2;
    [_dropDown addSubview:optionThree];
    [_dropDown addSubview:imageThree];
    
        [optionOne setAlpha:0.0];
        [optionTwo setAlpha:0.0];
        [optionThree setAlpha:0.0];
        [imageOne setAlpha:0.0];
        [imageTwo setAlpha:0.0];
        [imageThree setAlpha:0.0];
        [self.view insertSubview:_dropDown aboveSubview:_collectionView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dropDown attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}


-(IBAction)ListDroped:(id)sender{
    if(!_isDroped){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y + 192, CGRectGetWidth(initialCollectionViewFrame), CGRectGetHeight(initialCollectionViewFrame));
                [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
            [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect openedListFrame = CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64*4);
                [_dropDown setFrame:openedListFrame];
                _isDroped = YES;
                [imageOne setAlpha:1.0];
                [imageTwo setAlpha:1.0];
                [imageThree setAlpha:1.0];
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
            [imageOne setAlpha:0.0];
            [imageTwo setAlpha:0.0];
            [imageThree setAlpha:0.0];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.2 animations:^{
              CGRect dropDownFrame =CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64);
              [_dropDown setFrame:dropDownFrame];
              [showList setTitle:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle] forState:UIControlStateNormal];
              [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];

              self.collectionView.frame = initialCollectionViewFrame;
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
        _filterString =@"popularity.desc";
        _dropDownTitle=@"Most popular";
        [self setDropDownTitleButton];
        _selectedButton=0;
        
    }
    else if(sender.tag==1){
        _filterString =@"release_date.desc";
        _dropDownTitle=@"Latest";
        [self setDropDownTitleButton];
        _selectedButton=1;
    }
    else if(sender.tag==2){
        _filterString =@"vote_average.desc";
        _dropDownTitle=@"Highest Rated";
        [self setDropDownTitleButton];
        _selectedButton=2;
    }
    [self ListDroped:sender];
    [self setupButtons];
    if(_isMovie)
    {
        [self getMovies];
    }
    else{
        [self getShows];
    }
}

-(void)setupButtons{
    NSString *selectedButton =@"DropDownSelected";
    NSString *notSelectedButton=@"";
    NSString *buttonOne;
    NSString *buttonTwo;
    NSString *buttonThree;

    if(_selectedButton ==0){
        buttonOne=selectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
    }
    else if(_selectedButton ==1){
        buttonOne=notSelectedButton;
        buttonTwo=selectedButton;
        buttonThree=notSelectedButton;
    }
    else if(_selectedButton ==2){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=selectedButton;
    }
    [imageOne setImage:[UIImage imageNamed:buttonOne]];
    [imageTwo setImage:[UIImage imageNamed:buttonTwo]];
    [imageThree setImage:[UIImage imageNamed:buttonThree]];

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
    
        NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                          @"sort_by":localFilterString,
                                          @"primary_release_date.lte":currentDate,
                                          @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                          };
        queryParameters=queryParams;
    }
    
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
        NSLog(@"RestKit returned error: %@", error);
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
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"primary_release_date.lte":currentDate,
                                      @"page":_pageNumber,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        for(Movie *m in mappingResult.array){
            if(m.backdropPath!=nil && m.posterPath!=nil && m.releaseDate!=nil){
                [_allMovies addObject:m];
            }
        }

        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
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
        NSLog(@"RestKit returned error: %@", error);
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
    
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64" /*add your api*/
                                      };
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"primary_release_date.lte":currentDate,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    
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
        NSLog(@"RestKit returned error: %@", error);
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
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"primary_release_date.lte":currentDate,
                                      @"page":_pageNumber,
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        for(TVShow *tv in mappingResult.array){
            if(tv.posterPath!=nil && tv.backdropPath!=nil && tv.airDate!=nil){
                [_allShows addObject:tv];
            }
        }
        [self.collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
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
        NSLog(@"RestKit returned error: %@", error);
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


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(self.view.bounds) - 25) / 2;
    return CGSizeMake(width, width / 0.69);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
 
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
    
    if(_isLoged){
        if(_isMovie){
            if([[[_user watchlistMovies] valueForKey:@"movieID"] containsObject:_test.movieID]){
                [cell watchIt];
            }
            else{
                [cell unWatchIt];
            }
            if([[[_user favoriteMovies] valueForKey:@"movieID"] containsObject:_test.movieID]){
                [cell favoureIt];
            }
            else{
                [cell unFavoureIt];
            }
        }
        else{
            if([[[_user favoriteShows] valueForKey:@"showID"] containsObject:_tvTest.showID]){
                [cell favoureIt];
            }
            else{
                [cell unFavoureIt];
            }
            if([[[_user watchlistShows] valueForKey:@"showID"] containsObject:_tvTest.showID]){
                [cell watchIt];
            }
            else{
                [cell unWatchIt];
            }
        }
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
