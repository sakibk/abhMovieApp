//
//  FilmographyCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cast.h"

extern NSString *const filmographyCellIdentifier;

@interface FilmographyCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) NSNumber *actorID;
@property NSMutableArray<Cast *> *allCasts;
@property Cast *singleCast;

@end
