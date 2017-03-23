//
//  RLReconectedList.h
//  MovieApp
//
//  Created by Sakib Kurtic on 23/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLReconectedList : RLMObject

@property NSNumber<RLMInt> *mediaID;
@property NSString *listName;
@property BOOL isMovie;

@end
RLM_ARRAY_TYPE(RLReconectedList)
