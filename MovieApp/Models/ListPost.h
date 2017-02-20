//
//  ListPost.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListPost : NSObject

@property (strong, nonatomic) NSString *mediaType;
@property (strong, nonatomic) NSNumber *mediaID;
@property (nonatomic) NSNumber *isFavorite;
@property (nonatomic) NSNumber *isWatchlist;

@end
