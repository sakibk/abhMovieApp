//
//  RLMTrailerVideos.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "TrailerVideos.h"

@interface RLMTrailerVideos : RLMObject

@property (strong,nonatomic) NSString *videoKey;
@property (strong,nonatomic) NSString *videoName;
@property (strong, nonatomic) NSString *videoID;

-(id)initWithVideo:(TrailerVideos*)video;

@end
RLM_ARRAY_TYPE(RLMTrailerVideos)
