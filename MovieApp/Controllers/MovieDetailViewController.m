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


@interface MovieDetailViewController ()

@property Movie *movieDetail;
@property TVShow *showDetail;
@property NSNumber *actorID;
@property NSMutableArray<Season*> *allSeasons;

@property NSMutableArray<Review *> *allReviews;
@property Review *singleReview;

@property CGFloat imageCellHeigh;
@property CGFloat detailsCellHeight;
@property CGFloat overviewCellHeight;
@property CGFloat imageGalleryCellHeight;
@property CGFloat castCellHeight;
@property CGFloat reviewCellHeight;
@property CGFloat seasonsCellHeight;
@property CGFloat noCellHeight;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BellowImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BellowImageCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OverviewCellIdentifier];
    
      [self.tableView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ImageCollectionCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CastCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:castCollectionCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleReviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleReviewCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeasonsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:seasonsCellIdentifier];
    
    _allSeasons=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self setSizes];
    
    if(_isMovie){
        [self getMovies];
    }
    else{
        [self getShows];
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
    _seasonsCellHeight =59.0;
    _noCellHeight =0.0;
}

-(void)setNavBarTitle{
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
    if(_isMovie){
    self.navigationItem.title = _movieDetail.title;
    }
    else{
        self.navigationItem.title=_showDetail.name;
    }
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
        
        
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
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
        for(i=0;i<[mappingResult.array count];i++){
            if([[mappingResult.array objectAtIndex:i] isKindOfClass:[TVShow class]]){
                _showDetail = [mappingResult.array objectAtIndex:i];
                NSLog(@"%@", _showDetail.overview);
            }
            else if ([[mappingResult.array objectAtIndex:i] isKindOfClass:[Season class]]){
                [_allSeasons addObject:[mappingResult.array objectAtIndex:i]];
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
                PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
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
                SingleReviewCell *cell =(SingleReviewCell *)[tableView dequeueReusableCellWithIdentifier:singleReviewCellIdentifier forIndexPath:indexPath];
                _singleReview=[_allReviews objectAtIndex:indexPath.row];
                [cell setupWithReview:_singleReview]; // Configure the cell...
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return cell;
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
                PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
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
            return _allReviews != nil ? [_allReviews count] : 0;;
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
                return _allReviews != nil ?  @"Review" : @"";
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
    else if(indexPath.section == 5) {
        return _reviewCellHeight;
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section >0 && section <5){
    return 15;
    }
    else
        return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section>0) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
        if(section>1 || (_isMovie && section==5 && _allReviews!=nil)){
            UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,1)];
            lineview.layer.borderColor = [UIColor yellowColor].CGColor;
            lineview.layer.borderWidth = 0.5;
            [view addSubview:lineview];
        }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width/2, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
//    NSString *string =[list objectAtIndex:section];
    NSString *string =[self stringForSection:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
    return view;
    }
    else
        return nil;
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
                return _allReviews !=nil ? @"Review":nil;
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
        return _movieDetail != nil ? 6 : 0;
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
 if ([segue.identifier isEqualToString:@"ActorDetails"]){
 ActorDetailsViewController *actorDetail = segue.destinationViewController;
     actorDetail.actorID =_actorID;
 }
 else if ([segue.identifier isEqualToString:@"WatchTrailer"]){
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
     
 }

- (void)openImageGallery{
    [self performSegueWithIdentifier:@"ImageCollection" sender:self];
}

- (void)openActorWithID:(NSNumber *)actorID {
    _actorID=actorID;
    [self performSegueWithIdentifier:@"ActorDetails" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isMovie){
    if(indexPath.section==0){
        [self performSegueWithIdentifier:@"WatchTrailer" sender:self];
    }
    else if (indexPath.section==3){
        [self performSegueWithIdentifier:@"ImageCollection" sender:self];
    }
    }
    else{
        if (indexPath.section==4){
            [self performSegueWithIdentifier:@"ImageCollection" sender:self];
        }
        if(indexPath.section == 3){
            
            [self performSegueWithIdentifier:@"SeasonsViewIdentifier" sender:self];
        }
    }
}

@end
