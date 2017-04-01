//
//  TwoPickerCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const twoPickerCellIdentifier;
@interface TwoPickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView1;
@property (weak, nonatomic) IBOutlet UIButton *popPicker1;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage1;


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView2;
@property (weak, nonatomic) IBOutlet UIButton *popPicker2;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage2;
@end
