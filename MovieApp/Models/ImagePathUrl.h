//
//  ImagePathUrl.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@class RLMImagePaths;

@interface ImagePathUrl : NSObject

@property(strong, nonatomic) NSString *posterPath;

-(id)initWithPaths:(RLMImagePaths*)image;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
