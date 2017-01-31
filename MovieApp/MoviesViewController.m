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
#import <SDWebImage/UIImageView+WebCache.h>

@interface MoviesViewController ()

@property NSMutableArray<Movie *> *allMovies;
@property NSMutableArray<Genre *> *allGenres;
@property NSMutableArray<TVShow *> *allShows;
@property Movie *test;
@property TVShow *tvTest;
@property Genre *singleGenre;
@property (nonatomic,assign) BOOL *isMovie;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    [self getMovies];
    
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 1;
//}
-(void)getMovies{
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
                                      @"sort_by":@"popularity.desc",
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allMovies=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        [self setIsMovie:YES];
        
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
        [self getMovieGenres];
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
    RKObjectMapping *showMapping = [RKObjectMapping mappingForClass:[TVShow class]];
    
    [showMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                      @"vote_average": @"rating",
                                                      @"poster_path": @"posterPath",
                                                      @"first_air_date": @"airDate",
                                                      @"id": @"showID",
                                                      @"backdrop_path" : @"backdropPath",
                                                      @"overview": @"overview",
                                                      @"genre_ids": @"genreIds"
                                                      
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
                                      @"sort_by":@"popularity.desc",
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64" /*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allShows =[[NSMutableArray alloc]initWithArray:mappingResult.array];
                [self setIsMovie:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
    [self getTVGenres];
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


//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return CGSizeMake(175, 154);
//}

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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
        }
        else{
            _tvTest =[_allShows objectAtIndex:indexPath.row];
            movieDetails.singleShow = _tvTest;
            movieDetails.movieID = _tvTest.showID;
        }
    }
    
}


@end
