//
//  ActorDetailsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"
#import "FilmographyCell.h"
#import "Cast.h"
#import "AboutCell.h"

@interface ActorDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FilmographyCellDelegate,AboutCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSNumber *actorID;
-(void)searchForActor;

@end
