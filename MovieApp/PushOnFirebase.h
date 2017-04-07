//
//  PushOnFirebase.h
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import <Realm/Realm.h>
#import "RLMovie.h"
#import "RLMGenre.h"
#import "RLMCrew.h"
#import "RLMCast.h"
#import "DaysPlaying.h"
#import "Hours.h"
#import "Seats.h"
#import "PlayingHall.h"

@import Firebase;

@interface PushOnFirebase : NSObject

+(void)pushMoviesOnFirebase;

@end
