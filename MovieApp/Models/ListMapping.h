//
//  ListMapping.h
//  MovieApp
//
//  Created by Sakib Kurtic on 24/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Movie.h"
#import "TVShow.h"

@interface ListMapping : NSObject

@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSSet<Movie*> *movieList;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
