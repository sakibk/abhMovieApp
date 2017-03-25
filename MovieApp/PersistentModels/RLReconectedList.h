//
//  RLReconectedList.h
//  MovieApp
//
//  Created by Sakib Kurtic on 23/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "ReconnectedList.h"

@interface RLReconectedList : RLMObject

@property NSNumber<RLMInt> *mediaID;
@property NSNumber<RLMInt> *rate;
@property NSString *listName;
@property BOOL isMovie;
@property BOOL toSet;

-(id)initWithRL:(ReconnectedList*)rl;

@end
RLM_ARRAY_TYPE(RLReconectedList)
