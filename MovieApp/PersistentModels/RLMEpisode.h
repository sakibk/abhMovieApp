//
//  RLMEpisode.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Episode.h"

@interface RLMEpisode : RLMObject

@property (strong, nonatomic) NSNumber<RLMInt> *episodeNumber;
@property (strong, nonatomic) NSNumber<RLMInt> *seasonNumber;
@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSString *episodePoster;
@property (strong, nonatomic) NSString *episodeName;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber<RLMFloat> *rating;
@property (strong, nonatomic) NSNumber<RLMInt> *showID;

-(id)initWithEpisode:(Episode*)ep;

@end
RLM_ARRAY_TYPE(RLMEpisode)
