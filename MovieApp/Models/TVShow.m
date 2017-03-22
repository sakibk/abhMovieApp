//
//  TVShow.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TVShow.h"
#import "RLTVShow.h"
#import "Genre.h"
#import "RLMSeason.h"
#import "RLMCast.h"
#import "RLMCrew.h"
#import "ListType.h"

@implementation TVShow


+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"name": @"name",
                           @"vote_average": @"rating",
                           @"poster_path": @"posterPath",
                           @"air_date":@"airDate",
                           @"first_air_date": @"firstAirDate",
                           @"last_air_date":@"lastAirDate",
                           @"id": @"showID",
                           @"episode_run_time":@"runtime",
                           @"backdrop_path":@"backdropPath",
                           @"overview":@"overview",
                           @"genre_ids":@"genreIds",
                           @"number_of_seasons":@"seasonCount",
                           @"seasons":@"seasons",
                           @"in_production":@"inProduction"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[TVShow class]];
    [mapping addPropertyMapping:[RKRelationshipMapping
                                 relationshipMappingFromKeyPath:@"genres"
                                 toKeyPath:@"genreSet"
                                 withMapping:[Genre responseMapping]]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    
    mapping.assignsDefaultValueForMissingAttributes = NO;
    mapping.assignsNilForMissingRelationships=YES;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/tv/:id";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them. "
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[             [RKResponseDescriptor responseDescriptorWithMapping:[TVShow responseMapping] method:RKRequestMethodGET pathPattern:@"/3/discover/tv"
                                                                      keyPath:@"results"
                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

-(void)setupWithTVMovie:(TVMovie *)singleObject{
    self.showID=singleObject.TVMovieID;
    self.backdropPath=singleObject.backdropPath;
    self.airDate=singleObject.airDate;
    self.genreIds=singleObject.genreIds;
    self.name=singleObject.name;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    
}

- (id) initWithObject:(RLTVShow *)singleObject{
        self=[super init];
    
    self.showID=singleObject.showID;
    self.backdropPath=singleObject.backdropPath;
    self.airDate=singleObject.airDate;
    self.firstAirDate=singleObject.firstAirDate;
    self.lastAirDate=singleObject.lastAirDate;
    self.name=singleObject.name;
    self.rating=singleObject.rating;
    self.singleGenre = singleObject.singleGenre;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    self.userRate=singleObject.userRate;
    NSMutableArray *gns = [[NSMutableArray alloc] init];
    for(RLMGenre *g in singleObject.genres)
        [gns addObject:[[Genre alloc] initWithGenre:g] ];
    self.genres = [[NSArray alloc] initWithArray:gns];
    self.runtime = [[NSArray alloc] initWithObjects:singleObject.StartRuntime,singleObject.endRuntime,nil];
    for( RLMSeason *s in singleObject.seasons)
        [self.seasons addObject:[[Season alloc]initWithSeason:s]];
    for(RLMCrew *rcr in singleObject.showCrew)
        [self.crews addObject:[[Crew alloc] initWithCrew:rcr]];
    for(RLMCast *rcs in singleObject.showCast)
        [self.casts addObject:[[Cast alloc]initWithCast:rcs]];
    for(RLMListType *lt in singleObject.listType)
        [self.listType addObject:[[ListType alloc] initWithRLMListType:lt]];
    
    return self;
}

@end
