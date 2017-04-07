//
//  TrailerVideos.m
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TrailerVideos.h"
#import "RLMTrailerVideos.h"

@implementation TrailerVideos

-(id)initWithVideo:(RLMTrailerVideos*)video{
    self=[super init];
    self.videoID=video.videoID;
    self.videoName=video.videoName;
    self.videoKey=video.videoKey;
    return self;
}


// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"key": @"videoKey",
                           @"name": @"videoName",
                           @"id":@"videoID"
                           }
;
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[TrailerVideos class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/movie/:id/videos";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[TrailerVideos responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/season/:id/episode/:id/videos"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}


@end
