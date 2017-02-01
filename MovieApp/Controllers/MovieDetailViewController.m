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

@interface MovieDetailViewController ()

@property Movie *movieDetail;
@property TVShow *showDetail;


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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewsCellIdentifier" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reviewsCellIdentifier];
    
    
    // Do any additional setup after loading the view.
    
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
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
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
                                                       @"genres":@"genreSet"
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
        _showDetail = [mappingResult firstObject];
        NSLog(@"%@", _showDetail.overview);
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

-(void)setDetailPoster
{
//    [_detailPoster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w500",_movieDetail.backdropPath]]
//                     placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_movieDetail.title,@".png"]]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isMovie){
    switch (indexPath.row) {
        case 0:
        {
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovie:_movieDetail];
            return cell;
        }
            break;
        case 1:
        {
            BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovie:_movieDetail];
            return cell;
            
        }
            break;
        case 2:
        {
            OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovie:_movieDetail];
            return cell;
            
        }
            break;
        case 3:
        {
            ImageCollectionCell *cell = (ImageCollectionCell *)[tableView dequeueReusableCellWithIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovie:_movieDetail];
            return cell;
        }
            break;
        case 4:
        {
            CastCollectionCell *cell = (CastCollectionCell *)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovie:_movieDetail];
            return cell;
        }
            break;
        case 5:
        {
            ReviewsCell *cell = (ReviewsCell *)[tableView dequeueReusableCellWithIdentifier:reviewsCellIdentifier forIndexPath:indexPath];
            [cell setupWithMovieID:_movieID];
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
        switch (indexPath.row) {
            case 0:
            {
                PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                return cell;
            }
                break;
            case 1:
            {
                BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                return cell;
                
            }
                break;
            case 2:
            {
                OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                return cell;
                
            }
                break;
            case 3:
            {
                ImageCollectionCell *cell = (ImageCollectionCell *)[tableView dequeueReusableCellWithIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                return cell;
            }
                break;
            case 4:
            {
                CastCollectionCell *cell = (CastCollectionCell *)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
                [cell setupWithShow:_showDetail];
                return cell;
            }
                break;
            case 5:
            {
                ReviewsCell *cell = (ReviewsCell *)[tableView dequeueReusableCellWithIdentifier:reviewsCellIdentifier forIndexPath:indexPath];
                [cell setupWithShowID:_movieID];
                return cell;
            }
            default:
                break;
        }
        
        
        // Configure the cell...
        UITableViewCell *cell = [UITableViewCell new];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 222.0;
    }
    else if(indexPath.section == 0 && indexPath.row == 1) {
        return 42.0;
    }
    else if(indexPath.section == 0 && indexPath.row == 2) {
        return 180.0;
    }
    else if(indexPath.section == 0 && indexPath.row == 3) {
        return 185.0;
    }
    else if(indexPath.section == 0 && indexPath.row == 4) {
        return 293.0;
    }
    else if(indexPath.section == 0 && indexPath.row == 5) {
        return 330.0;
    }

    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string =[list objectAtIndex:section];
    NSString *string =@"test";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isMovie){
        return _movieDetail != nil ? 6 : 0;
    }
    else{
        return _showDetail != nil ? 7 : 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
