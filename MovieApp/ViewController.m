//
//  ViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import "Movie.h"
#import "Genre.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFRKHTTPClient *client = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    
    [movieMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                       @"vote_average": @"rating",
                                                       @"poster_path": @"posterPath",
                                                       @"release_date": @"releaseDate",
                                                       @"id": @"movieID"
                                                       }];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/3/movie/popular"
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    [manager addResponseDescriptor:responseDescriptor];
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @""/*add your api*/
                                      };
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/movie/popular" parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
