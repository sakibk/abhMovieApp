//
//  BookingViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "BookingViewController.h"
#import "PickerCell.h"
#import "TwoPickerCell.h"
#import "LegendCell.h"
#import "CollectionSeatsCell.h"

@interface BookingViewController ()
@property (strong,nonatomic)NSString *totalCost;

@property CGFloat legendCellHeigh;
@property CGFloat seatsCellHeight;
@property CGFloat nonPoppedTwoPickerHeight;
@property CGFloat poppedTwoPickerHeight;
@property CGFloat nonPopedHight;
@property CGFloat popedHight;
@property CGFloat buttonHeight;
@property CGFloat noCellHeight;

@end

@implementation BookingViewController{
        UIButton *bottomButton;
        UIView *bottomView;
        UILabel *totalLabel;
        BOOL isPickerViewExtended;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Do any additional setup after loading the view.
    _totalCost=@"TOTAL: $0.00";
    [self setNavBarTitle];
    [self createBottomButton];
    [self setupCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupCells{
    [_tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pickerCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"TwoPickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:twoPickerCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"LegendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:legendCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectionSeatsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:seatsCollectionCellIdentifier];
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text= @"";
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)createBottomButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"CHECKOUT" forState:UIControlStateNormal];
    [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3;
    [bottomButton addTarget:self action:@selector(pushCheckoutSummary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    CGRect totalRect = CGRectMake(20, 15, 100, 20);
    totalLabel = [[UILabel alloc] initWithFrame:totalRect];
    totalLabel.text=_totalCost;
    [totalLabel setContentMode:UIViewContentModeLeft];
    [totalLabel setFont:[UIFont systemFontOfSize:17.0]];
    [totalLabel setTextColor:[UIColor blackColor]];
    [self.view insertSubview:bottomView aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}

-(void)setSizes{
    _nonPoppedTwoPickerHeight=60;
    _poppedTwoPickerHeight=120;
    _nonPopedHight=60.0;
    _legendCellHeigh = 110;
    _popedHight=120.0;
    _buttonHeight=60; 
    _noCellHeight =0.0001;
}

-(void)pushCheckoutSummary{
    NSLog(@"Push checkout summary");
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            PickerCell *cell = (PickerCell*)[_tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:{
            TwoPickerCell *cell = (TwoPickerCell*)[_tableView dequeueReusableCellWithIdentifier:twoPickerCellIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
        case 2:{
            LegendCell *cell = (LegendCell*)[_tableView dequeueReusableCellWithIdentifier:legendCellIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
        case 3:{
            CollectionSeatsCell *cell = (CollectionSeatsCell*)[_tableView dequeueReusableCellWithIdentifier:seatsCollectionCellIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
            
        default:{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            return cell;
        }
            break;
    }
    return nil;
    }
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.00001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _noCellHeight;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hv =[[UIView alloc]init];
    [hv setBackgroundColor:[UIColor blackColor]];
    return hv;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
