//
//  RLMSeason.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMEpisode.h"
#import "Season.h"

@interface RLMSeason : RLMObject

@property (strong, nonatomic) NSNumber<RLMInt> *seasonID;
@property (strong, nonatomic) NSNumber<RLMInt> *seasonNumber;
@property (strong, nonatomic) NSNumber<RLMInt> *episodeCount;
@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) RLMArray<RLMEpisode*><RLMEpisode> *episodes;

-(id)initWithSeason:(Season*)season;

-(void)addToStoredEpisodes:(RLMEpisode*)ep;

@end
RLM_ARRAY_TYPE(RLMSeason)
