//
//  Token.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Token.h"

@implementation Token

// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"success": @"isSuccessful",
                           @"expires_at": @"expireDate",
                           @"status_code": @"statusCode",
                           @"status_message": @"statusMessage",
                           @"request_token": @"requestToken",
                           @"session_id": @"sessionID"
                           }
    ;
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Token class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/authentication/token/new";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[Token responseMapping] method:RKRequestMethodGET pathPattern:@"/3/authentication/token/validate_with_login"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Token responseMapping] method:RKRequestMethodGET pathPattern:@"/3/authentication/session/new"
                                                         keyPath:nil
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

- (id) initWithObject:(Token *)token{
    
    self.requestToken=token.requestToken;
    self.expireDate=token.expireDate;
    self.sessionID=token.sessionID;
    self.statusCode=token.statusCode;
    self.statusMessage=token.statusMessage;
    self.logedUsername=token.logedUsername;
    
    return self;
}
@end
