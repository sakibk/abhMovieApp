//
//  UserInfo.m
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"id": @"userID",
                           @"name": @"name",
                           @"username": @"userName"
                           }
    ;
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[UserInfo class]];
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
            path = @"/3/account";
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
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

- (id) initWithObject:(UserInfo *)user{
    
    self.name=user.name;
    self.userID=user.userID;
    self.userName=user.userName;
    self.session=user.session;
    self.favoriteMovies=user.favoriteMovies;
    self.favoriteShows=user.favoriteShows;
    self.watchlistMovies=user.watchlistMovies;
    self.watchlistShows=user.watchlistShows;
    self.ratedMovies=user.ratedMovies;
    self.ratedShows=user.ratedShows;
    
    return self;
}

@end
