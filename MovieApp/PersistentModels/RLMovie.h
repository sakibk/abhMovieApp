//
//  RLMovie.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Movie.h"
#import "RLMReview.h"
#import "RLMCrew.h"
#import "RLMCast.h"
#import "RLMTrailerVideos.h"

@interface RLMovie : RLMObject

//@property NSString *movieModelID;
@property NSNumber<RLMInt> *movieID;
@property NSString *title;
@property NSString *posterPath;
@property NSNumber<RLMFloat> *rating;
@property NSDate *releaseDate;
@property NSString *backdropPath;
@property NSString *singleGenre;
@property NSString *overview;
@property NSNumber<RLMInt> *userRate;
@property RLMArray<RLMReview*><RLMReview> *Reviews;
@property RLMArray<RLMCrew*><RLMCrew> *movieCrew;
@property RLMArray<RLMCast*><RLMCast> *movieCast;
@property RLMArray<RLMTrailerVideos*><RLMTrailerVideos> *videos;

-(void)addToStoredReviews:(RLMReview*)review;
-(void)addToStoredCasts:(RLMCast*)cast;
-(void)addToStoredCrew:(RLMCrew*)crew;
-(void)addToStoredVideos:(RLMTrailerVideos*)video;

-(id) initWithMovie:(Movie *)movie;
-(void)setupWithMovie:(Movie *)singleObject;

@end
RLM_ARRAY_TYPE(RLMovie);
