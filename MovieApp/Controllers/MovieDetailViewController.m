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

@interface MovieDetailViewController ()

@property Movie *movieDetail;

@end

@implementation MovieDetailViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
//    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
//    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    
    [movieMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"release_date": @"releaseDate",
                                                       @"id": @"movieID",
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
        _detailTitle.text = _movieDetail.title;
        NSLog(@"%@", _movieDetail.title);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    [_detailTitle setText:_movieDetail.title];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

-(void)setDetailPoster
{
    [_detailPoster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w500",_movieDetail.backdropPath]]
                     placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_movieDetail.title,@".png"]]];
    
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
