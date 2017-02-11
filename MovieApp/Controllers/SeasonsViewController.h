//
//  SeasonsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Season.h"

@interface SeasonsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *seasonYear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSNumber *seasonCount;
@property (strong,nonatomic) NSMutableArray<Season*> *seasons;
@property (strong,nonatomic) NSNumber *showID;
@property (strong,nonatomic) NSNumber *seasonID;

-(void)setupSeasonView;

@end
