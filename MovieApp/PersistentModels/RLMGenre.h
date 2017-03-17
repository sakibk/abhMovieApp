//
//  RLMGenre.h
//  MovieApp
//
//  Created by Sakib Kurtic on 17/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//
#import "Genre.h"
#import <Realm/Realm.h>

@interface RLMGenre : RLMObject

@property (strong, nonatomic) NSNumber<RLMInt> *genreID;
@property (strong,nonatomic) NSString *genreName;


-(id)initWithGenre:(Genre*)genre;
@end
RLM_ARRAY_TYPE(RLMGenre);
