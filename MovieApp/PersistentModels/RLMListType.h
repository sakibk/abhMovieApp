//
//  RLMListType.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "ListType.h"

@interface RLMListType : RLMObject

@property NSNumber<RLMInt> *listTypeID;
@property NSString *name;

-(id)initWithRLMListType:(ListType*)type;
-(id)initWithValues:(NSString*)typeName and:(NSNumber*)typeID;

@end
RLM_ARRAY_TYPE(RLMListType)
