//
//  RLMCast.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Cast.h"

@interface RLMCast : RLMObject

@property (strong, nonatomic) NSNumber<RLMInt> *castID;
@property (strong, nonatomic) NSNumber<RLMInt> *castWithID;
@property (strong, nonatomic) NSString *castName;
@property (strong, nonatomic) NSString *castRoleName;
@property (strong, nonatomic) NSString *castImagePath;
@property (strong, nonatomic) NSString *castPosterPath;
@property (strong, nonatomic) NSString *castMovieTitle;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *mediaType;


-(id)initWithCast:(Cast*)cast;

@end
RLM_ARRAY_TYPE(RLMCast)
