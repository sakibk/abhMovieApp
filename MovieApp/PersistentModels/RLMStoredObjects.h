//
//  StoredObjects.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMFeeds.h"

@interface RLMStoredObjects : RLMObject

@property NSString *objectID;
@property RLMArray<RLMFeeds*><RLMFeeds> *storedFeeds;

-(void)addToStoredFeeds:(RLMFeeds*)feed;

@end
