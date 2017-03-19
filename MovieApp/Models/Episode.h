//
//  Episode.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "TrailerVideos.h"
@class RLMEpisode;

@interface Episode : NSObject

@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSNumber *episodeNumber;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (strong, nonatomic) NSString *episodePoster;
@property (strong, nonatomic) NSString *episodeName;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *showID;
@property (strong,nonatomic) NSMutableArray<TrailerVideos*> *trailers;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

-(id)initWithEpisode:(RLMEpisode*)ep;

@end
