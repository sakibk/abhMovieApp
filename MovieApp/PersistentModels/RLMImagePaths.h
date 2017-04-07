//
//  RLMImagePaths.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "ImagePathUrl.h"

@interface RLMImagePaths : RLMObject

@property(strong, nonatomic) NSString *posterPath;

-(id)initWithPaths:(ImagePathUrl*)image;

@end
RLM_ARRAY_TYPE(RLMImagePaths)
