//
//  TwoPickerCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hours.h"
#import "DaysPlaying.h"

extern NSString *const twoPickerCellIdentifier;

@protocol TwoPickerCellDelegate <NSObject>

-(void)pushTicketNo:(NSNumber*)numberOfTickets;
-(void)pushSelectedHours:(Hours*)hoursSelected andPushSelectedString:(NSString*)selectedHourString;
-(void)pushSelectedString:(NSString*)selectedHourString;
-(IBAction)popOneOfTwoPickers:(id)sender;

@end

@interface TwoPickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView1;
@property (weak, nonatomic) IBOutlet UIButton *popPicker1;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage1;
@property (strong,nonatomic) NSMutableArray<NSString*> *stringsToShow;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UIButton *popPicker2;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage2;

@property (strong, nonatomic) Hours *selectedHours;
@property (strong, nonatomic) NSMutableArray<Hours*> *playingHours;
@property (strong, nonatomic) NSMutableArray<DaysPlaying*> *playingDays;

@property (strong, nonatomic) id<TwoPickerCellDelegate> delegate;

-(NSString*)setupStringsToShow;

@end
