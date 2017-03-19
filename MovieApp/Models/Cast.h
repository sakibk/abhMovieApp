//
//  Cast.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@class RLMCast;

@interface Cast : NSObject

@property (strong, nonatomic) NSNumber *castID;
@property (strong, nonatomic) NSNumber *castWithID;
@property (strong, nonatomic) NSString *castName;
@property (strong, nonatomic) NSString *castRoleName;
@property (strong, nonatomic) NSString *castImagePath;
@property (strong, nonatomic) NSString *castPosterPath;
@property (strong, nonatomic) NSString *castMovieTitle;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *mediaType;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

-(id)initWithCast:(RLMCast*)cast;

@end
