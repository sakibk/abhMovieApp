//
//  CheckoutSummaryViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 04/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seats.h"
#import "Movie.h"
#import "Hours.h"

@interface CheckoutSummaryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) NSMutableArray<Seats*> *selectedSeats;
@property(strong,nonatomic) Movie *selectedMovie;
@property(strong,nonatomic) NSNumber *amountToPay;
@property(strong,nonatomic) NSNumber *numberOfTickets;
@property(strong,nonatomic) Hours *selectedHours;
@property(strong, nonatomic) NSString *DateString;
@end
