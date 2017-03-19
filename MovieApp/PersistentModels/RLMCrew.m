//
//  RLMCrew.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMCrew.h"

@implementation RLMCrew

-(id)initWithCrew:(Crew*)crew{
    self = [super init];
    self.crewName = crew.crewName;
    self.jobName = crew.jobName;
    return self;
}

@end
