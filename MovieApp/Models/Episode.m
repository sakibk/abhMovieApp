//
//  Episode.m
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Episode.h"
#import "RLMEpisode.h"

@implementation Episode

-(id)initWithEpisode:(RLMEpisode*)ep{
    self= [super init];
    self.episodeNumber = ep.episodeNumber;
    self.seasonNumber = ep.seasonNumber;
    self.airDate = ep.airDate;
    self.episodePoster = ep.episodePoster;
    self.episodeName = ep.episodeName;
    self.overview = ep.overview;
    self.rating = ep.rating;
    self.showID = ep.showID;
    return self;
}

// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"air_date":@"airDate",
                           @"episode_number":@"episodeNumber",
                           @"still_path":@"episodePoster",
                           @"name":@"episodeName",
                           @"overview":@"overview",
                           @"season_number":@"seasonNumber",
                           @"vote_average":@"rating"
                           }
    ;
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Episode class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/tv/:id/season/:id";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[Episode responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/season/:id/episode/id"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

@end
