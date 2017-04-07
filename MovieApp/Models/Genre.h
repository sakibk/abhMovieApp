//
//  Genre.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <RestKit/RestKit.h>
@class RLMGenre;

@interface Genre : NSObject

@property (strong, nonatomic) NSNumber *genreID;
@property (strong,nonatomic) NSString *genreName;

-(id)initWithGenre:(RLMGenre*)genre;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
