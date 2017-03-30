//
//  PushOnFirebase.h
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;

@interface PushOnFirebase : NSObject{
    NSMutableArray<FIRDataSnapshot *> *comments;
    FIRDatabaseReference *postRef;
    FIRDatabaseReference *commentsRef;
}

+(void)pushMoviesOnFirebase;

@end
