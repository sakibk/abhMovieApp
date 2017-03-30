//
//  PickerCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const pickerCellIdentifier;

@protocol PickerCellDelegate <NSObject>

-(IBAction)popPicker:(id)sender;
-(void)pushStringValueTroughDelegate:(NSString*)selectedHour;

@end


@interface PickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray<NSString *> *hoursPlaying;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (strong, nonatomic) id<PickerCellDelegate> delegate;

-(void)setupWithSnap:(NSMutableArray<NSString*>*) playingHours;
@end
