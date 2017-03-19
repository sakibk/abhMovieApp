//
//  RLMEpisode.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMEpisode.h"

@implementation RLMEpisode

-(id)initWithEpisode:(Episode*)ep{
    self= [super init];
    self.episodeNumber = ep.episodeNumber;
    self.seasonNumber = ep.seasonNumber;
    self.airDate = ep.airDate;
    self.episodePoster = ep.episodePoster;
    self.episodeName = ep.episodeName;
    self.overview = ep.overview;
    self.rating = ep.rating;
    self.showID = ep.showID;
    return self;
}

@end



//@property (strong, nonatomic) NSNumber<RLMInt> *episodeNumber;
//@property (strong, nonatomic) NSNumber<RLMInt> *seasonNumber;
//@property (strong, nonatomic) NSDate *airDate;
//@property (strong, nonatomic) NSString *episodePoster;
//@property (strong, nonatomic) NSString *episodeName;
//@property (strong, nonatomic) NSString *overview;
//@property (strong, nonatomic) NSNumber<RLMFloat> *rating;
//@property (strong, nonatomic) NSNumber<RLMInt> *showID;
