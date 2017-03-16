//
//  ListMappingTV.h
//  MovieApp
//
//  Created by Sakib Kurtic on 15/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShow.h"
#import <RestKit/RestKit.h>

@interface ListMappingTV : UIControl

@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSSet<TVShow*> *showList;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
