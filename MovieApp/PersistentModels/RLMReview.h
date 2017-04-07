//
//  RLMReview.h
//  MovieApp
//
//  Created by Sakib Kurtic on 18/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Review.h"

@interface RLMReview : RLMObject

@property NSString *author;
@property NSString *text;

-(id)initWithReview:(Review*)rev;

@end
RLM_ARRAY_TYPE(RLMReview)
