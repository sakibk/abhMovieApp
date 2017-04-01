//
//  CollectionSeatsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const seatsCollectionCellIdentifier;
@interface CollectionSeatsCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
