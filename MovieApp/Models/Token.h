//
//  Token.h
//  MovieApp
//
//  Created by Sakib Kurtic on 17/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <RestKit/RestKit.h>

@interface Token : NSObject

@property (nonatomic) BOOL isSuccessful;
@property (nonatomic, strong) NSDate *expireDate;
@property (nonatomic, strong) NSString *requestToken;
@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) NSString *statusMessage;
@property (nonatomic, strong) NSString *logedUsername;

- (id) initWithObject:(Token *)token;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
