//
//  CollectionSeatsCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CollectionSeatsCell.h"
#import "SeatCell.h"

NSString *const seatsCollectionCellIdentifier=@"SeatsCollectionCellIdentifier";
@implementation CollectionSeatsCell{
    int i;
    int indexes[10][11];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [_collectionView registerNib:[UINib nibWithNibName:@"SeatCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:seatCellIdentifier];
    [self setupIndexes];
    [self.collectionView reloadData];
    _selectedSeats = [[NSMutableArray alloc]init];
    _seatNumber=[NSNumber numberWithInt:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupWithHallID:(NSNumber*)hallID andPlayingDayID:(NSNumber*)playingDayID andPlayingHourID:(NSNumber*)playingHourID{
    [self.seatsRef removeAllObservers];
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    _seatsRef = [[[[[ref child:@"Halls"] child:[NSString stringWithFormat:@"%@",hallID]] child:[NSString stringWithFormat:@"%@",playingDayID]] child:[NSString stringWithFormat:@"%@",playingHourID]] child:@"Seats"];
    [_seatsRef
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         i=0;
         _seats = [[NSMutableArray alloc] init];
         for(NSDictionary * dict in snapshot.value){
             [_seats addObject:[[Seats alloc] initWithSnap:dict andID:i]];
             i++;
         }
         [self.collectionView reloadData];
     }];
    [_seatsRef
     observeEventType:FIRDataEventTypeChildChanged
     withBlock:^(FIRDataSnapshot *snapshot) {
             int k;
             for(k=0; k<[_seats count];k++){
                 if([snapshot.value valueForKeyPath:@"row"] == [[_seats objectAtIndex:k] row]){
                     Seats *s = [_seats objectAtIndex:k];
                     s.taken=[[snapshot.value valueForKeyPath:@"taken"] boolValue];
                     [_seats replaceObjectAtIndex:k withObject:s];
                 }
             }
         [self.collectionView reloadData];
     }];
}
-(void)setupNumberOfSeatsToTake:(NSNumber*)numberOfSeats{
    _seatNumber=numberOfSeats;
}
-(void)pushSelectedSeat:(Seats*)seat{
    [_selectedSeats addObject:seat];
}

-(void)popSelectedSeat:(Seats*)seat{
    [_selectedSeats removeObject:seat];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 11;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat width = ([[UIScreen mainScreen]bounds].size.width-160)/11;
    CGFloat width = self.frame.size.width / 11;
    
    return CGSizeMake(width,width);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([_selectedSeats count]<=[_seatNumber integerValue]){
        SeatCell *cell =(SeatCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        [cell setupSelected];
    }
}

-(void)setupIndexes{
    int j,k,l;
    l=0;
    for(j=0;j<10;j++){
        for(k=0;k<11;k++){
            if(k == 2 || k == 8 ||(j==0 &&(k==0 || k==10))){

            }else{
                indexes[j][k] = l;
                l++;
            }
        }
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeatCell *cell = (SeatCell*)[_collectionView dequeueReusableCellWithReuseIdentifier:seatCellIdentifier forIndexPath:indexPath];
    if(indexPath.row == 2 || indexPath.row == 8 ||(indexPath.section == 0 &&( indexPath.row==0 || indexPath.row==10))){
        [cell setupNonSeatCell];
        [cell setUserInteractionEnabled:NO];
    }else{
        [cell setupSeatCell:[_seats objectAtIndex:indexes[indexPath.section][indexPath.row]]];
    }
    cell.delegate=self;
        return cell;
}

@end
