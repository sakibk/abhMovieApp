//
//  RLMActor.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Actor.h"

@interface RLMActor : RLMObject

@property(strong,nonatomic) NSNumber<RLMInt> *actorID;
@property(strong,nonatomic) NSNumber<RLMInt> *gender;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *nickName;
@property(strong,nonatomic) NSDate *birthDate;
@property(strong,nonatomic) NSDate *deathDate;
@property(strong,nonatomic) NSString *birthPlace;
@property(strong,nonatomic) NSString *homePage;
@property(strong,nonatomic) NSString *biography;
@property(strong,nonatomic) NSString *profilePath;

-(id)initWithActor:(Actor*)actor;

@end
RLM_ARRAY_TYPE(RLMActor)
