//
//  PostResponse.h
//  MovieApp
//
//  Created by Sakib Kurtic on 25/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostResponse : NSObject

@property (strong,nonatomic) NSString *statusMessage;
@property (strong,nonatomic) NSNumber *statusCode;

@end
