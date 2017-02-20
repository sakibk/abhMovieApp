//
//  UserInfo.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface UserInfo : NSObject

@property (strong, nonatomic)NSNumber *userID;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)Token *session;

@end
