//
//  ImageCollectionTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"

extern NSString * const ImageCollectionCellIdentifier;

@interface ImageCollectionCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)setupWithMovie:(Movie *)singleMovie;
-(void)setupWithShow:(TVShow *)singleShow;

@end
