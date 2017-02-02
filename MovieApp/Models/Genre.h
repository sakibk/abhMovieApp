//
//  Genre.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Genre : NSObject

@property (strong, nonatomic) NSNumber *genreID;
@property (strong,nonatomic) NSString *genreName;

@end
