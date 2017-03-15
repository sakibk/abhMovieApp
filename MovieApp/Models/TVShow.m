//
//  TVShow.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TVShow.h"
#import "RLTVShow.h"

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
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodPOST:
            path = @"";
            break;
            // This is an example.
        case RKRequestMethodGET:
            path = @"/3/tv/:id";
            break;
        case RKRequestMethodPUT:
            path = @"";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them. "
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[TVShow responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/on_the_air"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[TVShow responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/airing_today"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[TVShow responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/top_rated"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[TVShow responseMapping] method:RKRequestMethodGET pathPattern:@"/3/discover/tv"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"ShowId: %@, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@",self.showID, self.name, self.rating, self.posterPath, self.airDate];
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

- (id) initWithObject:(RLTVShow *)show{
        self=[super init];
    
    self.showID=show.showID ;
    self.backdropPath=show.backdropPath;
    self.airDate=show.airDate;
    self.name=show.name;
    self.rating=show.rating;
    self.posterPath=show.posterPath;
    self.overview=show.overview;
    self.userRate=show.userRate;
    
    return self;
}

@end
