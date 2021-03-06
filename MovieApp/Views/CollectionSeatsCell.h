//
//  CollectionSeatsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seats.h"
#import "SeatCell.h"

@import Firebase;

@protocol SeatsCollectionDelegate <NSObject>

-(void)pushSeatSelected:(Seats*)seat;
-(void)popSeatSelected:(Seats*)seat;
-(void)cleanSelectedSeats;

@end

extern NSString *const seatsCollectionCellIdentifier;
@interface CollectionSeatsCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource, SeatCellProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray<Seats*> *selectedSeats;
@property (strong,nonatomic) NSMutableArray<Seats*> *seats;
@property (strong,nonatomic) Seats *seat;
@property (strong, nonatomic) NSNumber *seatNumber;
@property(strong,nonatomic) FIRDatabaseReference *seatsRef;
@property (strong,nonatomic) id<SeatsCollectionDelegate> delegate;

-(void)setupNumberOfSeatsToTake:(NSNumber*)numberOfSeats;
-(void)setupWithHallID:(NSNumber*)hallID andPlayingDayID:(NSNumber*)playingDayID andPlayingHourID:(NSNumber*)playingHourID;
@end
