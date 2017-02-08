//
//  FilmographyCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FilmographyCell.h"
#import "SingleFilmographyCell.h"

NSString *const filmographyCellIdentifier=@"FilmographyCellIdentifier";

@implementation FilmographyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SingleFilmographyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:singleFilmographyCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allCasts != nil ? [_allCasts count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleFilmographyCell *cell = (SingleFilmographyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:singleFilmographyCellIdentifier forIndexPath:indexPath];
    _singleCast=[_allCasts objectAtIndex:indexPath.row];
    
    [cell setupWithCast:_singleCast];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(160.0, 293.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

@end
