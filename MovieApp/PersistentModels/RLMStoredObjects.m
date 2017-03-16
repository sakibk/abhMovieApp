//
//  StoredObjects.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMStoredObjects.h"

@implementation RLMStoredObjects

+ (NSString *)primaryKey {
    return @"objectID";
}

-(void)addToStoredFeeds:(RLMFeeds*)feed{
//    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.storedFeeds addObject:feed];
//    [[RLMRealm defaultRealm] commitWriteTransaction];
}


@end
