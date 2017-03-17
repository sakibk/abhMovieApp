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
#import "ConnectivityTest.h"
#import "RLUserInfo.h"
#import "ApiKey.h"
#import "RLMStoredObjects.h"
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
@property BOOL isConnected;
@property BOOL didScroll;

@property RLMRealm *realm;
@property RLMStoredObjects *storedObjetctMedia;

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
    UIButton *optionFour;
    UIButton *optionFive;
    UIImageView *imageOne;
    UIImageView *imageTwo;
    UIImageView *imageThree;
    UIImageView *imageFour;
    UIImageView *imageFive;
    UIImageView *dropDownImage;
    UIViewController *rootViewController;
    LeftViewController *leftViewController;
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
    _isConnected = [ConnectivityTest isConnected];
    _didScroll=YES;
    if(_isMovie)
    {
        if(_isConnected)
            [self getMovies];
        else
            [self getStoredMovies];
    }
    else{
        if(_isConnected)
            [self getShows];
        else
            [self getStoredTV];
    }
    [self CreateDropDownList];
    [self setNavBar];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
    [self.collectionView reloadData];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
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
        UIColor *backColor = [UIColor colorWithWhite:0.187 alpha:1.0];
        txtSearchField.backgroundColor =backColor;
        txtSearchField.textAlignment = NSTextAlignmentCenter;
        txtSearchField.placeholder = @"🔍 Search";
        [txtSearchField setValue:[UIColor lightGrayColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
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
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:^(void){
        [leftViewController.menuButton setAlpha:1.0];
    }];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //SearchViewIdentifier
    [self performSegueWithIdentifier:@"SearchViewIdentifier" sender:self];
    return NO;
}

-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@" Sorted by: %@",_dropDownTitle]];
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
    CGRect dropDownFrame =CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64);
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
    if(!_isMovie){
        buttonThreeFrame.size.height = buttonThreeFrame.size.height-1;
    }
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
    if(!_isMovie){
        
        CGRect pictureFourFrame = CGRectMake(22, 64*4+24 , 20, 15);
        imageFour = [[UIImageView alloc]initWithFrame:pictureFourFrame];
        [imageFour setImage:[UIImage imageNamed:@""]];
        CGRect buttonFourFrame = CGRectMake(0, 64*4, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
        optionFour = [[UIButton alloc]init];
        optionFour.frame=buttonFourFrame;
        optionFour.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
        [optionFour setBackgroundColor:[UIColor blackColor]];
        [optionFour setTitle:@"Airing Today" forState:UIControlStateNormal];
        optionFour.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [optionFour addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionFour.tag=3;
        [_dropDown addSubview:optionFour];
        [_dropDown addSubview:imageFour];
        
        CGRect pictureFiveFrame = CGRectMake(22, 64*5+24 , 20, 15);
        imageFive = [[UIImageView alloc]initWithFrame:pictureFiveFrame];
        [imageFive setImage:[UIImage imageNamed:@""]];
        CGRect buttonFiveFrame = CGRectMake(0, 64*5, [_dropDown bounds].size.width, [_dropDown bounds].size.height);
        optionFive = [[UIButton alloc]init];
        optionFive.frame=buttonFiveFrame;
        optionFive.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
        [optionFive setBackgroundColor:[UIColor blackColor]];
        [optionFive setTitle:@"On Air" forState:UIControlStateNormal];
        optionFive.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [optionFive addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        optionFive.tag=4;
        [_dropDown addSubview:optionFive];
        [_dropDown addSubview:imageFive];
        
    }
    
    [optionOne setAlpha:0.0];
    [optionTwo setAlpha:0.0];
    [optionThree setAlpha:0.0];
    [optionFour setAlpha:0.0];
    [optionFive setAlpha:0.0];
    [imageOne setAlpha:0.0];
    [imageTwo setAlpha:0.0];
    [imageThree setAlpha:0.0];
    [imageFour setAlpha:0.0];
    [imageFive setAlpha:0.0];
    
    [self.view insertSubview:_dropDown aboveSubview:_collectionView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dropDown attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}


-(IBAction)ListDroped:(id)sender{
    if(!_isDroped){
        
        [UIView animateWithDuration:0.2 animations:^{
            if(_isMovie){
                self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y + 192, CGRectGetWidth(initialCollectionViewFrame), CGRectGetHeight(initialCollectionViewFrame));
            }
            else{
                self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y + 320, CGRectGetWidth(initialCollectionViewFrame), CGRectGetHeight(initialCollectionViewFrame));
            }
            [self setButtonTitle];
            [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect openedListFrame;
                if(_isMovie){
                    openedListFrame = CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64*4);
                }
                else{
                    openedListFrame = CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64*6);
                }
                [_dropDown setFrame:openedListFrame];
                _isDroped = YES;
                [imageOne setAlpha:1.0];
                [imageTwo setAlpha:1.0];
                [imageThree setAlpha:1.0];
                [optionOne setAlpha:1.0];
                [optionTwo setAlpha:1.0];
                [optionThree setAlpha:1.0];
                if(!_isMovie){
                    [imageFour setAlpha:1.0];
                    [imageFive setAlpha:1.0];
                    [optionFour setAlpha:1.0];
                    [optionFive setAlpha:1.0];
                }
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
            if(!_isMovie){
                [imageFour setAlpha:0.0];
                [imageFive setAlpha:0.0];
                [optionFour setAlpha:0.0];
                [optionFive setAlpha:0.0];
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect dropDownFrame =CGRectMake(0, 74, [[UIScreen mainScreen] bounds].size.width, 64);
                [_dropDown setFrame:dropDownFrame];
                [self setButtonTitle];
                [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
                
                self.collectionView.frame = initialCollectionViewFrame;
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
    else if(sender.tag==3){
        _filterString =@"air_date.desc";
        _dropDownTitle=@"Airing Today";
        [self setDropDownTitleButton];
        _selectedButton=3;
    }
    else if(sender.tag==4){
        _filterString =@"first_air_date.desc";
        _dropDownTitle=@"On Air";
        [self setDropDownTitleButton];
        _selectedButton=4;
    }
    _pageNumber = [NSNumber numberWithInt:1];
    [self ListDroped:sender];
    if(_isMovie)
    {
        _pageNumber=[NSNumber numberWithInt:1];
        [self setupButtonsMovie];
        [self getMovies];
    }
    else{
        _pageNumber=[NSNumber numberWithInt:1];
        [self setupButtonsShows];
        [self getShows];
    }
}

-(void)setupButtonsMovie{
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

-(void)setupButtonsShows{
    NSString *selectedButton =@"DropDownSelected";
    NSString *notSelectedButton=@"";
    NSString *buttonOne;
    NSString *buttonTwo;
    NSString *buttonThree;
    NSString *buttonFour;
    NSString *buttonFive;
    
    if(_selectedButton ==0){
        buttonOne=selectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
    }
    else if(_selectedButton ==1){
        buttonOne=notSelectedButton;
        buttonTwo=selectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
    }
    else if(_selectedButton ==2){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=selectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
    }
    else if(_selectedButton ==3){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=selectedButton;
        buttonFive=notSelectedButton;
    }
    else if(_selectedButton ==4){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=selectedButton;
    }
    [imageOne setImage:[UIImage imageNamed:buttonOne]];
    [imageTwo setImage:[UIImage imageNamed:buttonTwo]];
    [imageThree setImage:[UIImage imageNamed:buttonThree]];
    [imageFour setImage:[UIImage imageNamed:buttonFour]];
    [imageFive setImage:[UIImage imageNamed:buttonFive]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getStoredMovies{
    RLMResults<RLMStoredObjects*> *objs = [RLMStoredObjects allObjects];
    if([objs count]){
        RLMStoredObjects *obj = objs.firstObject;
        _allMovies=[[NSMutableArray alloc] init];
        for(RLMovie *oneMovie in obj.storedPopularMovies){
            [_allMovies addObject:[[Movie alloc] initWithObject:oneMovie]];
        }
    }
    [self.collectionView reloadData];
}

-(void)getStoredTV{
    
}

-(void)getMovies{
    NSString *localFilterString = _filterString;
    NSString *pathP =@"/3/discover/movie";
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                      @"sort_by":@"primary_release_date.desc",
                                      @"primary_release_date.lte":[DateFormatter dateFromString:currentDate],
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    if([localFilterString isEqualToString:@"vote_average.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"vote_count.gte":@250,
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
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
        _didScroll=YES;
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
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"page":_pageNumber
                                      };
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
        NSDictionary *queryParams = @{
                                      @"sort_by":@"primary_release_date.desc",
                                      @"primary_release_date.lte":[DateFormatter dateFromString:currentDate],
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"page":_pageNumber
                                      };
        queryParameters=queryParams;
    }
    
    if([localFilterString isEqualToString:@"vote_average.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"vote_count.gte":@250,
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"page":_pageNumber
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
        _didScroll=YES;
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}


- (void)getMovieGenres
{
    NSString *pathP =@"/3/genre/movie/list";
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
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
    
    NSString *pathP =@"/3/discover/tv";
    
    NSDictionary *queryParameters = @{
                                      @"sort_by":localFilterString,
                                      @"api_key": [ApiKey getApiKey] /*add your api*/
                                      };
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
    NSString *tomorrowDate = [DateFormatter stringFromDate:[NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]]];
    
    
    if([localFilterString isEqualToString:@"first_air_date.desc"]){
        NSDictionary *queryParams = @{
                                          @"sort_by":@"popularity_desc",
                                          @"air_date.gte":currentDate,
                                          @"timezone":@"Sarajevo",
                                          @"api_key": [ApiKey getApiKey] /*add your api*/
                                          };
        queryParameters=queryParams;
    }
    if([localFilterString isEqualToString:@"air_date.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":@"popularity_desc",
                                      @"air_date.gte":currentDate,
                                      @"air_date:lte":tomorrowDate,
                                      @"timezone":@"Sarajevo",
                                      @"api_key": [ApiKey getApiKey] /*add your api*/
                                      };
        queryParameters=queryParams;

    }
    
    if([localFilterString isEqualToString:@"vote_average.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"vote_count.gte":@250,
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by": @"first_air_date.desc",
                                      @"first_air_date.lte":[DateFormatter dateFromString:currentDate],
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
        queryParameters=queryParams;
    }
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        if(_allShows!=nil){
            _allShows=nil;
            _allShows =[[NSMutableArray alloc]init];
            for(TVShow *tv in mappingResult.array){
                if(tv.posterPath!=nil && tv.backdropPath!=nil && tv.firstAirDate!=nil){
                    [_allShows addObject:tv];
                }
            }
            if([_allShows count]<4){
                [self getMoreShows];
            }
            [self.collectionView reloadData];
            [self setPageNumber:[NSNumber numberWithInt:1]];
        }
        else{
            _allShows =[[NSMutableArray alloc]initWithArray:mappingResult.array];
            [self.collectionView reloadData];
            [self setPageNumber:[NSNumber numberWithInt:1]];
        }
        _didScroll=YES;
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
                                      @"api_key": [ApiKey getApiKey], /*add your api*/
                                      @"page":_pageNumber
                                      };
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate=[DateFormatter stringFromDate:[NSDate date]];
    NSString *tomorrowDate = [DateFormatter stringFromDate:[NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]]];
    
    
    if([localFilterString isEqualToString:@"first_air_date.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":@"popularity_desc",
                                      @"air_date.gte":currentDate,
                                      @"timezone":@"Sarajevo",
                                      @"api_key": [ApiKey getApiKey], /*add your api*/
                                      @"page":_pageNumber
                                      };
        queryParameters=queryParams;
    }
    if([localFilterString isEqualToString:@"air_date.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":@"popularity_desc",
                                      @"air_date.gte":currentDate,
                                      @"air_date:lte":tomorrowDate,
                                      @"timezone":@"Sarajevo",
                                      @"api_key": [ApiKey getApiKey], /*add your api*/
                                      @"page":_pageNumber
                                      };
        queryParameters=queryParams;
        
    }
    
    if([localFilterString isEqualToString:@"vote_average.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by":localFilterString,
                                      @"vote_count.gte":@250,
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"page":_pageNumber
                                      };
        queryParameters=queryParams;
    }
    
    if([localFilterString isEqualToString:@"release_date.desc"]){
        NSDictionary *queryParams = @{
                                      @"sort_by": @"first_air_date.desc",
                                      @"first_air_date.lte":[DateFormatter dateFromString:currentDate],
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
                                      @"page":_pageNumber
                                      };
        queryParameters=queryParams;
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        for(TVShow *tv in mappingResult.array){
            if(tv.posterPath!=nil && tv.backdropPath!=nil && tv.firstAirDate!=nil){
                [_allShows addObject:tv];
            }
        }
        _didScroll=YES;
        [self.collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

- (void)getTVGenres
{
    NSString *pathP =@"/3/genre/tv/list";

    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
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
            if(_didScroll){
                [self getMoreMovies];
                _didScroll=NO;
            }
        }
        else{
            if(_didScroll){
                [self getMoreShows];
                _didScroll=NO;
            }
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
