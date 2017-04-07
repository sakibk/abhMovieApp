//
//  RLMCrew.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Crew.h"

@interface RLMCrew : RLMObject

@property (strong, nonatomic) NSString *jobName;
@property (strong, nonatomic) NSString *crewName;

-(id)initWithCrew:(Crew*)crew;

@end
RLM_ARRAY_TYPE(RLMCrew)
