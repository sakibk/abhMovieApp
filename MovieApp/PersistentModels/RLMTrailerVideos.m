//
//  RLMTrailerVideos.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMTrailerVideos.h"

@implementation RLMTrailerVideos

-(id)initWithVideo:(TrailerVideos*)video{
    self=[super init];
    self.videoID=video.videoID;
    self.videoName=video.videoName;
    self.videoKey=video.videoKey;
    return self;
}

@end
