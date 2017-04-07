//
//  MultiObject.m
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TVMovie.h"

@implementation TVMovie


-(BOOL)isMovie{
    return [self.mediaType isEqualToString:@"movie"];
}


// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"title": @"title",
                           @"release_date": @"releaseDate",
                           @"vote_average": @"rating",
                           @"poster_path": @"posterPath",
                           @"id": @"TVMovieID",
                           @"backdrop_path" : @"backdropPath",
                           @"overview": @"overview",
                           @"genre_ids":@"genreIds",
                           @"name": @"name",
                           @"first_air_date": @"airDate",
                           @"media_type":@"mediaType"
                           }

    ;
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[TVMovie class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/search/multi";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}


@end
