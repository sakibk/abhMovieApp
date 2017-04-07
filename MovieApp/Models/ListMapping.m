//
//  ListMapping.m
//  MovieApp
//
//  Created by Sakib Kurtic on 24/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ListMapping.h"

@implementation ListMapping

+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"page": @"page",
                           @"total_pages": @"pageCount"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [mapping addPropertyMapping:[RKRelationshipMapping
                                 relationshipMappingFromKeyPath:@"results"
                                 toKeyPath:@"movieList"
                                 withMapping:[Movie responseMapping]]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/account/:id/favorite/movies";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[ListMapping responseMapping] method:RKRequestMethodGET pathPattern:@"/3/account/:id/watchlist/movies"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[ListMapping responseMapping] method:RKRequestMethodGET pathPattern:@"/3/account/:id/rated/movies"
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
