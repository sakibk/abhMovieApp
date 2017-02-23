//
//  RLTVShow.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "TVShow.h"

@interface RLTVShow : RLMObject

@property NSNumber<RLMInt> *showID;
@property NSString *name;
@property NSString *posterPath;
@property NSNumber<RLMFloat> *rating;
@property NSDate *airDate;
@property NSString *backdropPath;
@property NSString *singleGenre;
@property NSString *overview;
@property NSNumber<RLMInt> *userRate;

- (id) initWithShow:(TVShow *)show;
-(void)setupWithShow:(TVShow *)singleObject;

@end
RLM_ARRAY_TYPE(RLTVShow);
