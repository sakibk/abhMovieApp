//
//  CollectionSeatsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seats.h"

@import Firebase;

extern NSString *const seatsCollectionCellIdentifier;
@interface CollectionSeatsCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray<Seats*> *seats;
@property (strong,nonatomic) Seats *seat;

@property(strong,nonatomic) FIRDatabaseReference *seatsRef;

-(void)setupWithHallID:(NSNumber*)hallID andPlayingDayID:(NSNumber*)playingDayID andPlayingHourID:(NSNumber*)playingHourID;
@end
