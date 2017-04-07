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

@interface PaymentsViewController : UIViewController<UITextFieldDelegate>

@property(strong, nonatomic) Hours *playingTerm;
@property(strong, nonatomic) NSMutableArray<Seats*> *selectedSeats;
@property(strong,nonatomic) NSString *buyerName;
@property(strong,nonatomic) NSNumber *totalAmount;
@property(strong,nonatomic) NSNumber *accountID;
@property(strong,nonatomic) NSString *seatsSelected;

@end
