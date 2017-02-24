//
//  ListMapping.h
//  MovieApp
//
//  Created by Sakib Kurtic on 24/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "TVShow.h"

@interface ListMapping : NSObject

@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSSet<Movie*> *movieList;
@property (strong, nonatomic) NSSet<TVShow*> *showList;

@end
