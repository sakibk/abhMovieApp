//
//  FirebaseDetailViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 28/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FirebaseDetailViewController.h"
#import "PictureDetailCell.h"
#import "BellowImageCell.h"
#import "OverviewCell.h"
#import "OverviewdLineCell.h"
#import "PickerCell.h"
#import "ButtonCell.h"

@interface FirebaseDetailViewController ()

@property NSMutableArray<NSNumber*> *cellOverviewHeights;

@property CGFloat imageCellHeigh;
@property CGFloat detailsCellHeight;
@property CGFloat overviewCellHeight;
@property CGFloat overviewLineCellHight;
@property CGFloat nonPopedHight;
@property CGFloat popedHight;
@property CGFloat buttonHeight;
@property CGFloat noCellHeight;
@property NSString *selectedHours;

@end

@implementation FirebaseDetailViewController
{
    UIButton *showList;
    UIImageView *dropDownImage;
    UIView *bottomView;
    BOOL isPickerViewExtended;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setCells];
    [self setSizes];
    [self setOverviewLineHeights:[[NSMutableArray alloc]initWithObjects:@"Neki direktor",@"neki producent",@"neka zvjezda", nil]];
    [self setNavBarTitle];
    isPickerViewExtended = NO;
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text= _singleMovie.title;
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)setCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BellowImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BellowImageCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OverviewCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewdLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:overviewLineCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pickerCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:buttonCellIdentifier];
}
-(void)setSizes{
    _imageCellHeigh =222.0;
    _detailsCellHeight =50.0;
    _overviewCellHeight =105;
    _overviewLineCellHight=20.0;
    _nonPopedHight=60.0;
    _popedHight=120.0;
    _buttonHeight=60;
    _noCellHeight =0.0001;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2){
        return 4;
    }
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithSnapMovie:_singleMovie];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:
        {
            BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
            [cell setupWithSnapMovie:_singleMovie];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
        case 2:
        {
            if(indexPath.row == 0){
                OverviewCell *cell = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
                [cell setupWithMovie:_singleMovie];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
                
            }
            else if(indexPath.row==1){
                return [self setupOverviewCellForTableView:tableView :indexPath :@"Director: " :[NSString stringWithFormat:@"%@",@"Tom Miller"]];
            }
            else if(indexPath.row==2){
                return [self setupOverviewCellForTableView:tableView :indexPath :@"Writers: " :[NSString stringWithFormat:@"%@",@"Rob Liefield"]];
            }
            else if(indexPath.row==3){
                return [self setupOverviewCellForTableView:tableView :indexPath :@"Stars: " :[NSString stringWithFormat:@"%@",@"Ben Aflek"]];
            }
            
        }
            break;
        case 3:{
            PickerCell *cell =(PickerCell *)[tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier forIndexPath:indexPath];
            [cell setupWithSnap:[[_singleMovie.playingDays objectAtIndex:[_indexPlayDay integerValue]] playingHours]];
            cell.delegate=self;
            return cell;
        }
            break;
        case 4:{
            ButtonCell *cell = (ButtonCell *)[tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
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
-(IBAction)popPicker:(id)sender{
    [self.tableView beginUpdates];
    if (isPickerViewExtended) {
        isPickerViewExtended = NO;
    } else {
        isPickerViewExtended = YES;
    }
    [self.tableView endUpdates];
}

-(void)pushStringValueTroughDelegate:(NSString*)selectedHour{
    _selectedHours=selectedHour;
}

-(OverviewLineCell *)setupOverviewCellForTableView:(UITableView*)tableView :(NSIndexPath*)indexPath :(NSString*)titlel :(NSString*)content{
    OverviewLineCell *cell = (OverviewLineCell *)[tableView dequeueReusableCellWithIdentifier:overviewLineCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.titleLabel setText:titlel];
    [cell.contentLabel setText:content];
    CGFloat afterHeight=[self heightForView:content :[UIFont systemFontOfSize:14.0] :cell.contentLabel.frame.size.width];
    [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight]];
    return cell;
}

-(CGFloat)heightForView :(NSString*)text :(UIFont *)font : (CGFloat)width{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    [label setNumberOfLines:0];
    [label setLineBreakMode: NSLineBreakByWordWrapping];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return  label.frame.size.height;
}

-(void)pushBookingView{
    NSLog(@"pushView");
}

-(void)setOverviewLineHeights:(NSMutableArray*)strings{
    _cellOverviewHeights = [[NSMutableArray alloc]init];
    [_cellOverviewHeights addObject:[NSNumber numberWithFloat:15.0]];
    int i;
    for (i=0; i<[strings count]; i++) {
        CGFloat afterHeight=[self heightForView:[strings objectAtIndex:i] :[UIFont systemFontOfSize:15.0] :[UIScreen mainScreen].bounds.size.width-84];
        [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight+3]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 && indexPath.row == 0){
        return _imageCellHeigh;
    }
    else if(indexPath.section ==1 && indexPath.row == 0){
            return _detailsCellHeight;
    }
    else if(indexPath.section ==2){
        if (indexPath.row==0)
            return _overviewCellHeight;
        else
            return [[_cellOverviewHeights objectAtIndex:indexPath.row] floatValue];
    }
    else if(indexPath.section ==3){
        if (isPickerViewExtended) {
            return _popedHight;
        }
        else{
            return _nonPopedHight;
        }
    }
    else if(indexPath.section == 4){
        return _buttonHeight;
    }
    else
        return _noCellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section>2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        return view;
    }
    else
        return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 4){
        NSLog(@"push controller");
    }
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
