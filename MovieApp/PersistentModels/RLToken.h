//
//  RLToken.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "Token.h"

@interface RLToken : RLMObject

@property BOOL isSuccessful;
@property NSDate *expireDate;
@property NSString *requestToken;
@property NSString *sessionID;
@property NSNumber<RLMInt> *statusCode;
@property NSString *statusMessage;
@property NSString *logedUsername;

- (id) initWithToken:(Token *)token;

@end
