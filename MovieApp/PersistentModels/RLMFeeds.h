//
//  RLMFeeds.h
//  MovieApp
//
//  Created by Sakib Kurtic on 14/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Feeds.h"

@interface RLMFeeds : RLMObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *desc;


@end
