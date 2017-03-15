//
//  ObjectMapper.m
//  MovieApp
//
//  Created by Adis Cehajic on 14/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ObjectMapper.h"
#import <RestKit/RestKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "Review.h"
#import "Cast.h"
#import "Crew.h"
#import "Season.h"
#import "Actor.h"
#import "TrailerVideos.h"
#import "TVMovie.h"
#import "Token.h"
#import "ImagePathUrl.h"

@implementation ObjectMapper

+(void)setObjectManagerMapping {
    [self mappingForObjectClass:[Genre class] requestKeyPath:nil responseKeyPath:@"genres"];
    [self mappingForObjectClass:[Movie class] requestKeyPath:nil responseKeyPath:nil];
    [self mappingForObjectClass:[TVShow class] requestKeyPath:nil responseKeyPath:nil];
    [self mappingForObjectClass:[ImagePathUrl class] requestKeyPath:nil responseKeyPath:@"posters"];
    [self mappingForObjectClass:[Cast class] requestKeyPath:nil responseKeyPath:@"cast"];
    [self mappingForObjectClass:[Crew class] requestKeyPath:nil responseKeyPath:@"crew"];
    [self mappingForObjectClass:[Review class] requestKeyPath:nil responseKeyPath:@"results"];
    [self mappingForObjectClass:[Season class] requestKeyPath:nil responseKeyPath:@"seasons"];
    [self mappingForObjectClass:[Actor class] requestKeyPath:nil responseKeyPath:nil];
    [self mappingForObjectClass:[TrailerVideos class] requestKeyPath:nil responseKeyPath:@"results"];
    [self mappingForObjectClass:[TVMovie class] requestKeyPath:nil responseKeyPath:@"results"];
    [self mappingForObjectClass:[Episode class] requestKeyPath:nil responseKeyPath:@"episodes"];


    
}

+(RKRequestMethod)requestMethodForIndex:(int)index{
    RKRequestMethod requestMethod;
    switch (index) {
        case 1:
            requestMethod = RKRequestMethodPOST;
            break;
        case 2:
            requestMethod = RKRequestMethodPUT;
            break;
        case 3:
            requestMethod = RKRequestMethodDELETE;
            break;
        default:
            requestMethod = RKRequestMethodGET;
            break;
    }
    return requestMethod;
}
//Class<TMRObjectMappingDelegate> umjesto ovog class
+(void)mappingForObjectClass:(Class)class requestKeyPath:(NSString*)requestKeyPath responseKeyPath:(NSString*)responseKeyPath{
    
    for (int i = 0; i < 4; i ++)
    {
        RKRequestMethod requestMethod = [self requestMethodForIndex:i];
        if([class pathPatternForRequestMethod:requestMethod])
        {
            RKRoute *route = [RKRoute routeWithClass:class pathPattern:[class pathPatternForRequestMethod:requestMethod] method:requestMethod];
            route.shouldEscapePath = YES;
            [RKObjectManager.sharedManager.router.routeSet addRoute:route];
            
            [RKObjectManager.sharedManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[class responseMapping] method:requestMethod pathPattern:[class pathPatternForRequestMethod:requestMethod] keyPath:responseKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
            
            [RKObjectManager.sharedManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[class responseMapping].inverseMapping objectClass:class rootKeyPath:requestKeyPath method:requestMethod]];
        }
    }
    [RKObjectManager.sharedManager addRequestDescriptorsFromArray:[class additionalRequestDescriptors]];
    [RKObjectManager.sharedManager addResponseDescriptorsFromArray:[class additionalResponseDescriptors]];
}



@end
