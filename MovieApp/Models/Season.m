//
//  Season.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Season.h"
#import "RLMSeason.h"

@implementation Season

// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"id": @"seasonID",
                           @"air_date": @"airDate",
                           @"season_number": @"seasonNumber",
                           @"poster_path": @"posterPath",
                           @"episode_count":@"episodeCount"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Season class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
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

-(id)initWithSeason:(RLMSeason*)season{
    self= [super init];
    self.seasonID=season.seasonID;
    self.seasonNumber=season.seasonNumber;
    self.episodeCount=season.episodeCount;
    self.airDate =season.airDate;
    self.posterPath=season.posterPath;
    
    return self;
}


@end
