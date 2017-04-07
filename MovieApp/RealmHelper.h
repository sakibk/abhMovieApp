//
//  RealmHelper.h
//  MovieApp
//
//  Created by Sakib Kurtic on 17/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RealmHelper : NSObject

+(void)putInto:(RLMArray*)arr :(RLMObject *)obj;
+(void)deleteAllIn:(RLMArray*)arr;

@end
