//
//  ListMappingTV.m
//  MovieApp
//
//  Created by Sakib Kurtic on 15/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ListMappingTV.h"

@implementation ListMappingTV


+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"page": @"page",
                           @"total_pages": @"pageCount"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ListMappingTV class]];
    [mapping addPropertyMapping:[RKRelationshipMapping
                                 relationshipMappingFromKeyPath:@"results"
                                 toKeyPath:@"showList"
                                 withMapping:[TVShow responseMapping]]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/account/:id/favorite/tv";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[ListMappingTV responseMapping] method:RKRequestMethodGET pathPattern:@"/3/account/:id/watchlist/tv"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[ListMappingTV responseMapping] method:RKRequestMethodGET pathPattern:@"/3/account/:id/rated/tv"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[ListMappingTV responseMapping] method:RKRequestMethodGET pathPattern:@"/3/tv/airing_today"
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
