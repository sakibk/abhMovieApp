//
//  RKObjectManager+SharedInstances.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RKObjectManager+SharedInstances.h"


@implementation RKObjectManager (SharedInstances)
+ (instancetype)boxOfficeManager
{
    static dispatch_once_t pred;
    static RKObjectManager *manager;
    NSURL *baseURLBoxOffice = [NSURL URLWithString:@"http://www.boxofficemojo.com"];
    AFRKHTTPClient *clientBoxOffice = [[AFRKHTTPClient alloc] initWithBaseURL:baseURLBoxOffice];
    dispatch_once(&pred, ^{
//        sharedObject = // whatever
        manager = [[RKObjectManager alloc] initWithHTTPClient:clientBoxOffice];
    });
    return manager;
}

@end
