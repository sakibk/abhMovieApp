//
//  Cast.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Cast.h"
#import "RLMCast.h"

@implementation Cast

+ (NSDictionary*)elementToPropertyMappings {
    NSDictionary *dict=@{
            @"cast_id": @"castID",
            @"character": @"castRoleName",
            @"id": @"castWithID",
            @"name": @"castName",
            @"profile_path": @"castImagePath",
            @"poster_path": @"castPosterPath",
            @"title":@"castMovieTitle",
            @"release_date":@"releaseDate",
            @"media_type":@"mediaType"
    };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Cast class]];
    
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/movie/:id/credits";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[Cast responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/credits"
                                                         keyPath:@"cast"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Cast responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/season/:id/episode/:id/credits"
                                                         keyPath:@"cast"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Cast responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/season/:id/episode/:id/credits"
                                                         keyPath:@"guest_stars"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Cast responseMapping] method:RKRequestMethodGET pathPattern:@"/3/person/:id/combined_credits"
                                                         keyPath:@"cast"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

-(id)initWithCast:(RLMCast*)cast{
    self= [super init];
    self.castID = cast.castID;
    self.castWithID = cast.castWithID;
    self.castName = cast.castName;
    self.castRoleName = cast.castRoleName;
    self.castImagePath = cast.castImagePath;
    self.castPosterPath = cast.castPosterPath;
    self.castMovieTitle = cast.castMovieTitle;
    self.releaseDate = cast.releaseDate;
    self.mediaType = cast.mediaType;
    return self;
}


@end
