//
//  ImagePathUrl.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ImagePathUrl.h"

@implementation ImagePathUrl

+ (NSDictionary*)elementToPropertyMappings {
    NSDictionary *dict = @{@"file_path": @"posterPath"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ImagePathUrl class]];
    
    
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
            path = @"/3/tv/:id/images";
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
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[ImagePathUrl responseMapping] method:RKRequestMethodGET pathPattern:@"/3/movie/:id/images"
                                                         keyPath:@"posters"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}



@end
