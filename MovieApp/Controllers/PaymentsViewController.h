//
//  PaymentsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 05/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hours.h"
#import "Seats.h"

@interface PaymentsViewController : UIViewController

@property(strong, nonatomic) Hours *playingTerm;
@property(strong, nonatomic) NSMutableArray<Seats*> *selectedSeats;

@end
