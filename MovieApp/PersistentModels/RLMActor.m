//
//  RLMActor.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMActor.h"

@implementation RLMActor

-(id)initWithActor:(Actor*)actor{
    self = [super init];
    self.name=actor.name;
    if([actor.nickNames firstObject])
        self.nickName = [actor.nickNames firstObject];
    self.biography = actor.biography;
    self.birthDate = actor.birthDate;
    self.birthPlace = actor.birthPlace;
    self.actorID = actor.actorID;
    self.profilePath = actor.profilePath;
    self.deathDate = actor.deathDate;
    self.gender = actor.gender;
    self.homePage = actor.homePage;
    return self;
}

@end
