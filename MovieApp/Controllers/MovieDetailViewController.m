//
//  MovieDetailViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 20/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <RestKit/RestKit.h>
#import "Movie.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PictureDetailCell.h"
#import "BellowImageCell.h"
#import "OverviewCell.h"
#import "ImageCollectionCell.h"
#import "CastCollectionCell.h"
#import "ReviewsCell.h"
#import "SeasonsCell.h"
#import "ActorDetailsViewController.h"
#import "TrailerViewController.h"
#import "ImagesViewController.h"
#import "SeasonsViewController.h"
#import "SingleReviewCell.h"
#import "Review.h"
#import "RatingViewController.h"
#import "ListPost.h"
#import "RLUserInfo.h"


@interface MovieDetailViewController ()

@property Movie *movieDetail;
@property TVShow *showDetail;
@property NSNumber *actorID;
@property NSMutableArray<Season*> *allSeasons;

@property NSMutableArray<Review *> *allReviews;
@property Review *singleReview;
@property NSIndexPath *pictureIndexPath;

@property CGFloat imageCellHeigh;
@property CGFloat detailsCellHeight;
@property CGFloat overviewCellHeight;
@property CGFloat imageGalleryCellHeight;
@property CGFloat castCellHeight;
@property CGFloat reviewCellHeight;
@property CGFloat openReviewCellHeight;
@property CGFloat seasonsCellHeight;
@property CGFloat noCellHeight;

@property RLMRealm *realm;
@property RLUserInfo *user;

@property NSIndexPath *reviewIndexPath;
@property BOOL isOpened;
@property NSMutableArray<NSIndexPath*> *buttonsIndexPath;
@property NSMutableArray<NSNumber*> *cellReviewHeights;

@property BOOL isSuccessful;

@end

@implementation MovieDetailViewController
{
    bool isRowOpen[20];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self setCells];
    [self setupUser];
    // Do any additional setup after loading the view.
    [self setSizes];
    
    if(_isMovie){
        [self getMovies];
    }
    else{
        [self getShows];
    }
    
}

-(void)setupUser{
    _allSeasons=[[NSMutableArray alloc]init];
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        _user = [users firstObject];
    }
}


- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
    }
    
    - (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
    }

-(void)setSizes{
    _imageCellHeigh =222.0;
    _detailsCellHeight =42.0;
    _overviewCellHeight =180.0;
    _imageGalleryCellHeight =185.0;
    _castCellHeight =293.0;
    _reviewCellHeight =160.0;
    _openReviewCellHeight=290.0;
    _seasonsCellHeight =59.0;
    _noCellHeight =0.0;
}

-(void)setCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BellowImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BellowImageCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OverviewCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ImageCollectionCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CastCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:castCollectionCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleReviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleReviewCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeasonsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:seasonsCellIdentifier];
    
    _realm=[RLMRealm defaultRealm];
    _isOpened=NO;
    int i;
    for(i=0 ; i<20 ; i++){
        isRowOpen[i]=NO;
    }
    _buttonsIndexPath=[[NSMutableArray alloc]init];
    _isSuccessful=NO;
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 330, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    if(_isMovie){
    titleLabel.text= _movieDetail.title;
    }
    else{
        titleLabel.text=_showDetail.name;
    }
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}

-(void)getMovies{
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    
    [movieMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"release_date": @"releaseDate",
                                                       @"id": @"movieID",
                                                       @"runtime":@"runtime",
                                                       @"backdrop_path":@"backdropPath",
                                                       @"overview":@"overview",
                                                       @"genres":@"genreSet"
                                                       }];
    
    movieMapping.assignsDefaultValueForMissingAttributes = YES;
    
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@", @"/3/movie/", _movieID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    NSLog(@"%@", pathP);
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _movieDetail = [mappingResult firstObject];
        NSLog(@"%@", _movieDetail.overview);
        [self setupReviewsWithMovieID:_movieDetail.movieID];
        [self setNavBarTitle];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

-(void) setupReviewsWithMovieID:(NSNumber *)singleMovieID{
    
    RKObjectMapping *reviewMapping = [RKObjectMapping mappingForClass:[Review class]];
    
    [reviewMapping addAttributeMappingsFromDictionary:@{@"author": @"author",
                                                        @"content": @"text"
                                                        }];
    reviewMapping.assignsDefaultValueForMissingAttributes = YES;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", singleMovieID,@"/reviews"];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:reviewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allReviews=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        [self setupHeights];
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}
-(void)setupHeights{
    _cellReviewHeights= [[NSMutableArray alloc]init];
    int i;
    for(i=0 ; i<[_allReviews count] ;i++){
        [_cellReviewHeights addObject:[NSNumber numberWithFloat:_reviewCellHeight]];
    }
}


-(void)getShows{
    RKObjectMapping *showMapping = [RKObjectMapping mappingForClass:[TVShow class]];
    
    [showMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"first_air_date": @"firstAirDate",
                                                       @"last_air_date":@"lastAirDate",
                                                       @"id": @"showID",
                                                       @"episode_run_time":@"runtime",
                                                       @"backdrop_path":@"backdropPath",
                                                       @"overview":@"overview",
                                                       @"genres":@"genreSet",
                                                       @"number_of_seasons":@"seasonCount",
                                                      @"seasons":@"seasons"
                                                       }];
    
    showMapping.assignsDefaultValueForMissingAttributes = YES;
    
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@", @"/3/tv/", _movieID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:showMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    NSLog(@"%@", pathP);
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        int i;
        if(mappingResult.array.firstObject!= nil){
        for(i=0;i<[mappingResult.array count];i++){
            if([[mappingResult.array objectAtIndex:i] isKindOfClass:[TVShow class]]){
                _showDetail = [mappingResult.array objectAtIndex:i];
                NSLog(@"%@", _showDetail.overview);
            }
            else if ([[mappingResult.array objectAtIndex:i] isKindOfClass:[Season class]]){
                [_allSeasons addObject:[mappingResult.array objectAtIndex:i]];
            }
        }
        }
        _showDetail.seasons=_allSeasons;
        [self setNavBarTitle];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isMovie){
        switch (indexPath.section) {
            case 0:
            {
                _pictureIndexPath=indexPath;
                PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithMovie:_movieDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            case 1:
            {
                BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
                [cell setupWithMovie:_movieDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }
                break;
            case 2:
            {
                OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithMovie:_movieDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }
                break;
            case 3:
            {
                ImageCollectionCell *cell = (ImageCollectionCell *)[tableView dequeueReusableCellWithIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithMovie:_movieDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            case 4:
            {
                CastCollectionCell *cell = (CastCollectionCell *)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithMovie:_movieDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            case 5:
            {
                if(_allReviews.firstObject != nil ){
                SingleReviewCell *cell =(SingleReviewCell *)[tableView dequeueReusableCellWithIdentifier:singleReviewCellIdentifier forIndexPath:indexPath];
                _singleReview=[_allReviews objectAtIndex:indexPath.row];
                [cell setupWithReview:_singleReview]; // Configure the cell...
                    cell.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.readMoreButton setTag:indexPath.row];
                    [_buttonsIndexPath addObject:indexPath];
                return cell;
                }
            }
            default:
                break;
        }
        
        
        // Configure the cell...
        UITableViewCell *cell = [UITableViewCell new];
        return cell;
    }
    else{
        switch (indexPath.section) {
            case 0:
            {
                _pictureIndexPath=indexPath;
                PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithShow:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            case 1:
            {
                BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }
                break;
            case 2:
            {
                OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithShow:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }
                break;
            case 3:
            {
                SeasonsCell *cell = (SeasonsCell *)[tableView dequeueReusableCellWithIdentifier:seasonsCellIdentifier forIndexPath:indexPath];
                [cell setupWithShowID:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.delegate = self;
                return cell;
                
            }
                break;
            case 4:
            {
                ImageCollectionCell *cell = (ImageCollectionCell *)[tableView dequeueReusableCellWithIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithShow:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            case 5:
            {
                CastCollectionCell *cell = (CastCollectionCell *)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
                cell.delegate=self;
                [cell setupWithShow:_showDetail];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
                break;
            default:
                break;
        }
        
        
        // Configure the cell...
        UITableViewCell *cell = [UITableViewCell new];
        return cell;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isMovie){
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 1;
        }
            break;
        case 2:{
            return 1;
        }
            break;
        case 3:{
            return 1;
        }
            break;
        case 4:{
            return 1;
        }
            break;
        case 5:{
            return _allReviews.firstObject != nil ? [_allReviews count] : 0;;
        }
            break;
        default: return 0;
            break;
    }
}
    else{
        switch (section) {
            case 0:{
                return 1;
            }
                break;
            case 1:{
                return 1;
            }
                break;
            case 2:{
                return 1;
            }
                break;
            case 3:{
                return 1;
            }
                break;
            case 4:{
                return 1;
            }
                break;
            case 5:{
                return 1;
            }
                break;
            default: return 0;
                break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(_isMovie){
        switch (section) {
            case 0:{
                return nil;
            }
                break;
            case 1:{
                return @"";
            }
                break;
            case 2:{
                return @"";
            }
                break;
            case 3:{
                return @"Image gallery";
            }
                break;
            case 4:{
                return @"Cast";
            }
                break;
            case 5:{
                return _allReviews.firstObject != nil ?  @"Review" : @"";
            }
                break;
            default: return nil;
                break;
        }
    }
    else{
        switch (section) {
            case 0:{
                return nil;
            }
                break;
            case 1:{
                return @"";
            }
                break;
            case 2:{
                return @"";
            }
                break;
            case 3:{
                return @"";
            }
                break;
            case 4:{
                return @"Image gallery";
            }
                break;
            case 5:{
                return @"Cast";
            }
                break;
            default: return nil;
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(_isMovie){
    if(indexPath.section == 0 && indexPath.row == 0) {
        return _imageCellHeigh;
    }
    else if(indexPath.section == 1 && indexPath.row == 0) {
        return _detailsCellHeight;
    }
    else if(indexPath.section == 2 && indexPath.row == 0) {
        return _overviewCellHeight;
    }
    else if(indexPath.section == 3 && indexPath.row == 0) {
        return _imageGalleryCellHeight;
    }
    else if(indexPath.section == 4 && indexPath.row == 0) {
        return _castCellHeight;
    }
    else if(indexPath.section == 5 && _allReviews.firstObject != nil) {
        return [[_cellReviewHeights objectAtIndex:indexPath.row] floatValue];
    }

    return _noCellHeight;
    }
    else{
        if(indexPath.section == 0 && indexPath.row == 0) {
            return _imageCellHeigh;
        }
        else if(indexPath.section == 1 && indexPath.row == 0) {
            return _detailsCellHeight;
        }
        else if(indexPath.section == 2 && indexPath.row == 0) {
            return _overviewCellHeight;
        }
        else if(indexPath.section == 3 && indexPath.row == 0) {
            return _seasonsCellHeight;
        }
        else if(indexPath.section == 4 && indexPath.row == 0) {
            return _imageGalleryCellHeight;
        }
        else if(indexPath.section == 5 && indexPath.row == 0) {
            return _castCellHeight;
        }
        return _noCellHeight;
    }
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    for(NSIndexPath *path in indexPaths){
        [self tableView:_tableView heightForRowAtIndexPath:path];
      }
}


-(CGFloat)heightForView :(NSString*)text :(UIFont *)font : (CGFloat)width{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    [label setNumberOfLines:0];
    [label setLineBreakMode: NSLineBreakByWordWrapping];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return  label.frame.size.height;
}

- (void)readMore:(id)sender{
    NSIndexPath *currentIndexPath = [_buttonsIndexPath objectAtIndex:[sender tag]];
    SingleReviewCell *cell = (SingleReviewCell*)[_tableView cellForRowAtIndexPath:currentIndexPath];
    CGFloat beforeHeight = cell.contentLabel.frame.size.height;
    CGFloat afterHeight=[self heightForView:[[_allReviews objectAtIndex:currentIndexPath.row] text] :[UIFont systemFontOfSize:14.0] :cell.contentLabel.frame.size.width];
    _openReviewCellHeight=_reviewCellHeight + (afterHeight - beforeHeight);
    BOOL isSelectedRowOpened = isRowOpen[[sender tag]];
    if(!isSelectedRowOpened){
        [_cellReviewHeights setObject:[NSNumber numberWithFloat:_openReviewCellHeight] atIndexedSubscript:[sender tag]];
        [cell.readMoreButton setTitle:@"Read less" forState:UIControlStateNormal];
        isRowOpen[[sender tag]]=YES;
    }
    else{
        [_cellReviewHeights setObject:[NSNumber numberWithFloat:_reviewCellHeight] atIndexedSubscript:[sender tag]];
        [cell.readMoreButton setTitle:@"Read more" forState:UIControlStateNormal];
        isRowOpen[[sender tag]]=NO;
    }
    _reviewIndexPath = currentIndexPath;
    NSArray* rowsToReload = [NSArray arrayWithArray:_buttonsIndexPath];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section >0 && section <5){
    return 15;
    }
    else
        return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section>1) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
            UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,1)];
            lineview.layer.borderColor = [UIColor yellowColor].CGColor;
            lineview.layer.borderWidth = 0.5;
            [view addSubview:lineview];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width/2, 18)];
        UIFont *font1 = [UIFont boldSystemFontOfSize:14];
    [label setFont:font1];
    NSString *string =[self stringForSection:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
        if((section == 4 && !_isMovie) || (section==3 && _isMovie)){
            CGFloat buttonSize = 60;
            UIButton * seeAll = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-buttonSize, 10,buttonSize,20)];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            UIColor *yCol = [UIColor yellowColor];
            [style setAlignment:NSTextAlignmentCenter];
            NSDictionary *dict1 = @{NSFontAttributeName:font1,
                                    NSParagraphStyleAttributeName:style,
                                    NSForegroundColorAttributeName:yCol};
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"See All" attributes:dict1]];
            [seeAll setAttributedTitle:attString forState:UIControlStateNormal];
                [seeAll addTarget:self action:@selector(openImages:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:seeAll];
        }
    return view;
    }
    else
        return nil;
}

-(IBAction)openImages:(id)sender{
    [self performSegueWithIdentifier:@"ImageCollection" sender:self];
}

-(NSString*)stringForSection:(long)section{
    if(_isMovie){
        switch (section) {
            case 0:{
                return nil;
            }
                break;
            case 1:{
                return @"";
            }
                break;
            case 2:{
                return @"";
            }
                break;
            case 3:{
                return @"Image gallery";
            }
                break;
            case 4:{
                return @"Cast";
            }
                break;
            case 5:{
                return _allReviews.firstObject !=nil ? @"Review":nil;
            }
                break;
            default: return nil;
                break;
        }
    }
    else{
        switch (section) {
            case 0:{
                return nil;
            }
                break;
            case 1:{
                return @"";
            }
                break;
            case 2:{
                return @"";
            }
                break;
            case 3:{
                return @"";
            }
                break;
            case 4:{
                return @"Image gallery";
            }
                break;
            case 5:{
                return @"Cast";
            }
                break;
            default: return nil;
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isMovie){
        if(_movieDetail != nil){
            if(_allReviews.firstObject != nil){
                return 6;
            }
            else{
                return 5;
            }
        }
        else{
            return 0;
        }
    }
    else{
        return _showDetail != nil ? 6 : 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"WatchTrailer"]){
     TrailerViewController *trailer = segue.destinationViewController;
     if(_isMovie){
        [trailer setupWithMovieID:_movieID andOverview:_movieDetail.overview];     }
     else{
         [trailer setupWithMovieID:_movieID andOverview:_showDetail.overview];
     }
 }
 else if ([segue.identifier isEqualToString:@"ImageCollection"]){
     ImagesViewController *images = segue.destinationViewController;
     if(_isMovie){
         [images setupWithMovie:_singleMovie];
     }
     else{
         [images setupWithShow:_singleShow];
     }
 }
 else if([segue.identifier isEqualToString:@"SeasonsViewIdentifier"]){
     SeasonsViewController *seasons= segue.destinationViewController;
     seasons.seasonCount=_showDetail.seasonCount;
     seasons.seasons = _showDetail.seasons;
     seasons.singleShow=_showDetail;
     seasons.seasonID=[NSNumber numberWithInt:1];
     [seasons setupSeasonView];
 }
 else if ([segue.identifier isEqualToString:@"RateMedia"]){
     RatingViewController *rateMe = segue.destinationViewController;
     if(_isMovie){
         [rateMe setupWithMovie:_singleMovie];
     }
     else{
         [rateMe setupWithShow:_singleShow];
     }
 }
     
 }

-(void)allSeasonsView{
    [self performSegueWithIdentifier:@"SeasonsViewIdentifier" sender:self];
}

- (void)openImageGallery{
//    [self performSegueWithIdentifier:@"ImageCollection" sender:self];
}

- (void)openActorWithID:(NSNumber *)actorID {
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActorDetailsViewController *actorDetails = [storyboard instantiateViewControllerWithIdentifier:@"ActorDetails"];
    actorDetails.actorID = actorID;

    [viewControllers addObject:actorDetails];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

-(void)rateMedia{
    [self performSegueWithIdentifier:@"RateMedia" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isMovie){
    if(indexPath.section==0){
        [self performSegueWithIdentifier:@"WatchTrailer" sender:self];
    }
    }
}


-(void)addFavorite{
    PictureDetailCell *cell = (PictureDetailCell*)[_tableView cellForRowAtIndexPath:_pictureIndexPath];
        if(_isMovie){
            if(![[[_user favoriteMovies] valueForKey:@"movieID"] containsObject:_movieID]){
                [self noRestkitPost:@"favorite":@"true"];
                if(_isSuccessful){
                    [_user addToFavoriteMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
                    
                }
            }
            else{
                [self noRestkitPost:@"favorite":@"false"];
                if(_isSuccessful){
                    [_user deleteFavoriteMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
                    
                }
            }
        }
        else{
            if(![[[_user favoriteShows] valueForKey:@"showID"] containsObject:_movieID]){
                [self noRestkitPost:@"favorite":@"true"];
                if(_isSuccessful)
                    [_user addToFavoriteShows:[[RLTVShow alloc]initWithShow:_singleShow]];
            }
            else{
                [self noRestkitPost:@"favorite":@"false"];
                if(_isSuccessful)
                    [_user deleteFavoriteShows:[[RLTVShow alloc]initWithShow:_singleShow]];
            }
        }
    
//    [self postToList:@"favorites"];
}


-(void)addWatchlist{
    PictureDetailCell *cell = (PictureDetailCell*)[_tableView cellForRowAtIndexPath:_pictureIndexPath];
        if(_isMovie){
            if(![[[_user watchlistMovies] valueForKey:@"movieID"] containsObject:_movieID]){
                [self noRestkitPost:@"watchlist":@"true"];
                if(_isSuccessful){
                    [_user addToWatchlistMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
                    [cell watchIt];
                    _isSuccessful=NO;
                }
            }
            else{
                [self noRestkitPost:@"watchlist":@"false"];
                if(_isSuccessful){
                    [_user deleteWatchlistMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
                    [cell unWatchIt];
                    _isSuccessful=NO;
                }
            }
        }
        else{
            if(![[[_user watchlistShows] valueForKey:@"showID"] containsObject:_movieID]){
                [self noRestkitPost:@"watchlist":@"true"];
                if(_isSuccessful){
                    [_user addToWatchlistShows:[[RLTVShow alloc]initWithShow:_singleShow]];
                    [cell watchIt];
                    _isSuccessful=NO;
                }
            }
            else{
                [self noRestkitPost:@"watchlist":@"false"];
                if(_isSuccessful){
                    [_user deleteWatchlistShows:[[RLTVShow alloc]initWithShow:_singleShow]];
                    [cell unWatchIt];
                    _isSuccessful=NO;
                }
            }
        }
    
}

-(void)noRestkitPost:(NSString*)list :(NSString*)postOrDelete{
    NSError *error;
    
     NSString *pathP = [NSString stringWithFormat:@"https://api.themoviedb.org/3/account/%@/%@?api_key=%@&session_id=%@",[_userCredits objectForKey:@"userID"],list,@"893050c58b2e2dfe6fa9f3fae12eaf64",[_userCredits objectForKey:@"sessionID"]];
    
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
    
    ListPost *postObject = [ListPost new];
    if(_isMovie){
        postObject.mediaID= _singleMovie.movieID;
        postObject.mediaType=@"movie";
    }
    else{
        postObject.mediaID=_singleShow.showID;
        postObject.mediaType=@"tv";
    }
    NSDictionary *dataMapped = @{@"media_type" : postObject.mediaType,
                                 @"media_id" : postObject.mediaID,
                                 [NSString stringWithFormat:@"%@",list] : @NO
                                 };
    
    if([postOrDelete isEqualToString:@"true"]){
        NSDictionary *mappedData = @{@"media_type" : postObject.mediaType,
                                     @"media_id" : postObject.mediaID,
                                     [NSString stringWithFormat:@"%@",list] : @YES
                                     };
        dataMapped=mappedData;
    }
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataMapped options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error){
            if([[dictionary valueForKey:@"status_code"] intValue]==1){
                NSLog(@"Successfuly added");
                _isSuccessful=YES;
            }
            else if([[dictionary valueForKey:@"status_code"] intValue]==13){
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

-(void)postToList:(NSString*)list :(NSString*)postOrDelete{
    NSString *pathP = [NSString stringWithFormat:@"/3/account/%@/%@?api_key=%@&session_id=%@",[_userCredits objectForKey:@"userID"],list, @"893050c58b2e2dfe6fa9f3fae12eaf64", [_userCredits objectForKey:@"sessionID"]];
    
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:201]];
    
    RKObjectMapping *requestMapping= [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"status_code", @"status_message"]];
    
    RKRequestDescriptor *watchlistRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSDictionary class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectMapping *watchlistMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    
    [watchlistMapping addAttributeMappingsFromArray:@[@"status_code", @"status_message"]];
    
    watchlistMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *watchlistResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:watchlistMapping
                                                                                                     method:RKRequestMethodGET
                                                                                                pathPattern:pathP
                                                                                                    keyPath:nil statusCodes:statusCodesRK];
//
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:@"application/json"];
    [[RKObjectManager sharedManager] addRequestDescriptor:watchlistRequestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:watchlistResponseDescriptor];
    
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    ListPost *postObject = [ListPost new];
    if(_isMovie){
    postObject.mediaID= _singleMovie.movieID;
    postObject.mediaType=@"movie";
    }
    else{
        postObject.mediaID=_singleShow.showID;
        postObject.mediaType=@"tv";
    }
    postObject.isWatchlist=[NSNumber numberWithBool:NO];
    
    NSDictionary *queryParameters = @{
                                      @"media_type" : postObject.mediaType,
                                      @"media_id" : postObject.mediaID,
                                      [NSString stringWithFormat:@"%@",list] : [NSString stringWithFormat:@"%@",postOrDelete]
                                      };

    
    
    [[RKObjectManager sharedManager] postObject:nil path:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

@end
