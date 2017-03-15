//
//  Crew.m
//  MovieApp
//
//  Created by Sakib Kurtic on 28/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Crew.h"

@implementation Crew

+ (NSDictionary*)elementToPropertyMappings {
    NSDictionary *dict=@{
            @"job": @"jobName",
            @"name": @"crewName"
            };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Crew class]];
    
    
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
            path = @"/3/movie/:id/credits";
            break;
        case RKRequestMethodPUT:
            path = @"";
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
             [RKResponseDescriptor responseDescriptorWithMapping:[Crew responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/credits"
                                                         keyPath:@"crew"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Crew responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/:id/season/:id/episode/:id/credits"
                                                         keyPath:@"crew"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}



@end
