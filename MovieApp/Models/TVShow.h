//
//  TVShow.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
#import <Realm/Realm.h>

@interface TVShow : NSObject

@property int showID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSDate *airDate;
@property RLMArray<Genre *> *genres;

@end
