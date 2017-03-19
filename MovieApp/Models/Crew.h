//
//  Crew.h
//  MovieApp
//
//  Created by Sakib Kurtic on 28/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@class RLMCrew;

@interface Crew : NSObject

@property (strong, nonatomic) NSString *jobName;
@property (strong, nonatomic) NSString *crewName;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

-(id)initWithCrew:(RLMCrew*)crew;

@end
