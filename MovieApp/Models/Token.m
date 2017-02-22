//
//  Token.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Token.h"

@implementation Token


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
