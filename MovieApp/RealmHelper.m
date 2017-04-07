//
//  RealmHelper.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RealmHelper.h"

@implementation RealmHelper

+(void)putInto:(RLMArray*)arr :(RLMObject *)obj{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [arr addObject:obj];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
}

+(void)deleteAllIn:(RLMArray*)arr{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [arr removeAllObjects];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
