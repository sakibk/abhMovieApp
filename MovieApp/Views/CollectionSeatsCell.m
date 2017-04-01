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
@implementation CollectionSeatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [_collectionView registerNib:[UINib nibWithNibName:@"SeatCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:seatCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 11;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([[UIScreen mainScreen]bounds].size.width-40)/11;
    return CGSizeMake(width,width);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SeatCell *cell =(SeatCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell setYellowCircle];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != 2 || indexPath.row != 8 ||(indexPath.section == 1 &&( indexPath.row==0 || indexPath.row==10))){
        SeatCell *cell = (SeatCell*)[_collectionView dequeueReusableCellWithReuseIdentifier:seatCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else
        return nil;
}

@end
