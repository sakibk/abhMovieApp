//
//  RLTVShow.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "TVShow.h"
#import "RLMCrew.h"
#import "RLMCast.h"
#import "RLMSeason.h"
#import "RLMListType.h"
#import "RLMImagePaths.h"

@interface RLTVShow : RLMObject

//@property NSString *ShowModelID;
@property NSNumber<RLMInt> *showID;
@property NSString *name;
@property NSString *posterPath;
@property NSNumber<RLMFloat> *rating;
@property NSDate *airDate;
@property NSString *backdropPath;
@property NSString *singleGenre;
@property NSString *overview;
@property NSNumber<RLMInt> *userRate;
@property RLMArray<RLMCast*><RLMCast> *showCast;
@property RLMArray<RLMCrew*><RLMCrew> *showCrew;
@property RLMArray<RLMSeason*><RLMSeason> *seasons;
@property RLMArray<RLMListType*><RLMListType> *listType;
@property RLMArray<RLMImagePaths*><RLMImagePaths> *images;

- (id) initWithShow:(TVShow *)show;
-(void)setupWithShow:(TVShow *)singleObject;

-(void)addToStoredSeasons:(RLMSeason*)season;
-(void)addToStoredCasts:(RLMCast*)cast;
-(void)addToStoredCrew:(RLMCrew*)crew;

@end
RLM_ARRAY_TYPE(RLTVShow);
