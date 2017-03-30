//
//  FirebaseViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FirebaseViewController.h"
#import "CinemaCell.h"
#import "Movie.h"
#import "FirebaseDetailViewController.h"

@import Firebase;

@interface FirebaseViewController ()
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *comments;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *commentsRef;
@property(strong, nonatomic) NSMutableArray<Movie*> *allMovies;
@property(strong, nonatomic) NSMutableArray<Movie*> *showingMovie;

@property NSString *dropDownTitle;
@property int selectedButton;
@property (nonatomic,strong) UIView *dropDown;
@property (nonatomic,assign) BOOL isDroped;
@property (nonatomic,assign) BOOL isNavBarSet;

@end

@implementation FirebaseViewController{
    FIRDatabaseHandle _refHandle;
    UIButton *butt;
    CGRect initialTableViewFrame;
    UIButton *showList;
    UIButton *optionOne;
    UIButton *optionTwo;
    UIButton *optionThree;
    UIButton *optionFour;
    UIButton *optionFive;
    UIButton *optionSix;
    UIButton *optionSeven;
    UIImageView *imageOne;
    UIImageView *imageTwo;
    UIImageView *imageThree;
    UIImageView *imageFour;
    UIImageView *imageFive;
    UIImageView *imageSix;
    UIImageView *imageSeven;
    UIImageView *dropDownImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self setupView];
    //    [self setupButton];
    [self setupVariables];
    [self CreateDropDownList];
    [self setObservers];
}

-(void)setupView{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
    [self setNavBarTitle];
    
}
-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
        titleLabel.text= @"Cinema";

    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)setupVariables{
    _isDroped = NO;
    _isNavBarSet=NO;
    _dropDownTitle=@"Movies";
    _selectedButton = 0;
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [ref child:@"Movies"];
    self.commentsRef = [ref child:@"Movies"];
    self.comments =[[NSMutableArray alloc] init];
    _allMovies = [[NSMutableArray alloc] init];
    _showingMovie = [[NSMutableArray alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CinemaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cinemaCellIdentifier];
}

-(void)setObservers{
    [_commentsRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [self.comments addObject:snapshot];
         [_allMovies addObject:[[Movie alloc] initWithSnap:snapshot.value]];
         [self setupShowingMovies];
         [self.tableView reloadData];
     }];
    // Listen for deleted comments in the Firebase database
    [_commentsRef
     observeEventType:FIRDataEventTypeChildRemoved
     withBlock:^(FIRDataSnapshot *snapshot) {
     }];
    // [END child_event_listener]
    
    _refHandle = [_postRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        // [START_EXCLUDE]
        NSLog(@"%@",postDict);
        // [END_EXCLUDE]
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandle];
    [self.commentsRef removeAllObservers];
}


//#setupButtons
-(void)setupButton{
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGRect a = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 60);
    butt = [[UIButton alloc] initWithFrame:a];
    [butt setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [butt addTarget:self action:@selector(addToFirebase:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    
}

-(IBAction)addToFirebase:(id)sender{
    [[[[FIRDatabase database].reference child:@"users"] child:@""]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         NSDictionary *comment = @{@"uid": @"",
                                   @"author": @"",
                                   @"text": @""};
         [[_commentsRef childByAutoId] setValue:comment];
         
     }];
}
//#setup dropdown menu
-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@" Filter by: %@",_dropDownTitle]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, 11)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor lightGrayColor]
                 range:NSMakeRange(11, [text length]-11)];
    [showList setAttributedTitle:text forState:UIControlStateNormal];
}

-(void)CreateDropDownList{
    CGRect imageFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.width/8, 27 , 20 , 10);
    dropDownImage =[[UIImageView alloc] initWithFrame:imageFrame];
    [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
    CGRect dropDownFrame =CGRectMake(0, 14, [[UIScreen mainScreen] bounds].size.width, 64);
    _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
    [_dropDown setBackgroundColor:[UIColor darkGrayColor]];
    CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    showList = [[UIButton alloc]init];
    showList.frame = buttonFrame;
    [showList setBackgroundColor:[UIColor blackColor]];
    showList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    showList.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setButtonTitle];
    [showList addTarget:self action:@selector(ListDroped:) forControlEvents:UIControlEventTouchUpInside];
    [_dropDown addSubview:showList];
    [_dropDown addSubview:dropDownImage];
    
    CGRect pictureOneFrame = CGRectMake(22, 64+24 , 20, 15);
    imageOne = [[UIImageView alloc]initWithFrame:pictureOneFrame];
    [imageOne setImage:[UIImage imageNamed:@"DropDownSelected"]];
    CGRect buttonOneFrame = CGRectMake(0, 64, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionOne = [[UIButton alloc]init];
    optionOne.frame=buttonOneFrame;
    optionOne.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionOne setBackgroundColor:[UIColor blackColor]];
    [optionOne setTitle:@"Monday" forState:UIControlStateNormal];
    optionOne.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionOne addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionOne.tag=0;
    [_dropDown addSubview:optionOne];
    [_dropDown addSubview:imageOne];
    
    CGRect pictureTwoFrame = CGRectMake(22, 64*2+24 , 20, 15);
    imageTwo = [[UIImageView alloc]initWithFrame:pictureTwoFrame];
    [imageTwo setImage:[UIImage imageNamed:@""]];
    CGRect buttonTwoFrame = CGRectMake(0, 64*2, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionTwo = [[UIButton alloc]init];
    optionTwo.frame=buttonTwoFrame;
    optionTwo.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionTwo setBackgroundColor:[UIColor blackColor]];
    [optionTwo setTitle:@"Tuesday" forState:UIControlStateNormal];
    optionTwo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionTwo addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionTwo.tag=1;
    [_dropDown addSubview:optionTwo];
    [_dropDown addSubview:imageTwo];
    
    CGRect pictureThreeFrame = CGRectMake(22, 64*3+24 , 20, 15);
    imageThree = [[UIImageView alloc]initWithFrame:pictureThreeFrame];
    [imageThree setImage:[UIImage imageNamed:@""]];
    CGRect buttonThreeFrame = CGRectMake(0, 64*3, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    
    optionThree = [[UIButton alloc]init];
    optionThree.frame=buttonThreeFrame;
    optionThree.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionThree setBackgroundColor:[UIColor blackColor]];
    [optionThree setTitle:@"Wednesday" forState:UIControlStateNormal];
    optionThree.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionThree addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionThree.tag=2;
    [_dropDown addSubview:optionThree];
    [_dropDown addSubview:imageThree];
    
    CGRect pictureFourFrame = CGRectMake(22, 64*4+24 , 20, 15);
    imageFour = [[UIImageView alloc]initWithFrame:pictureFourFrame];
    [imageFour setImage:[UIImage imageNamed:@""]];
    CGRect buttonFourFrame = CGRectMake(0, 64*4, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionFour = [[UIButton alloc]init];
    optionFour.frame=buttonFourFrame;
    optionFour.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionFour setBackgroundColor:[UIColor blackColor]];
    [optionFour setTitle:@"Thursday" forState:UIControlStateNormal];
    optionFour.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionFour addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionFour.tag=3;
    [_dropDown addSubview:optionFour];
    [_dropDown addSubview:imageFour];
    
    CGRect pictureFiveFrame = CGRectMake(22, 64*5+24 , 20, 15);
    imageFive = [[UIImageView alloc]initWithFrame:pictureFiveFrame];
    [imageFive setImage:[UIImage imageNamed:@""]];
    CGRect buttonFiveFrame = CGRectMake(0, 64*5, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionFive = [[UIButton alloc]init];
    optionFive.frame=buttonFiveFrame;
    optionFive.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionFive setBackgroundColor:[UIColor blackColor]];
    [optionFive setTitle:@"Friday" forState:UIControlStateNormal];
    optionFive.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionFive addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionFive.tag=4;
    [_dropDown addSubview:optionFive];
    [_dropDown addSubview:imageFive];
    
    CGRect pictureSixFrame = CGRectMake(22, 64*6+24 , 20, 15);
    imageSix = [[UIImageView alloc]initWithFrame:pictureSixFrame];
    [imageSix setImage:[UIImage imageNamed:@""]];
    CGRect buttonSixFrame = CGRectMake(0, 64*6, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    optionSix = [[UIButton alloc]init];
    optionSix.frame=buttonSixFrame;
    optionSix.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionSix setBackgroundColor:[UIColor blackColor]];
    [optionSix setTitle:@"Saturday" forState:UIControlStateNormal];
    optionSix.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionSix addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionSix.tag=5;
    [_dropDown addSubview:optionSix];
    [_dropDown addSubview:imageSix];
    
    CGRect pictureSevenFrame = CGRectMake(22, 64*7+24 , 20, 15);
    imageSeven = [[UIImageView alloc]initWithFrame:pictureSevenFrame];
    [imageSeven setImage:[UIImage imageNamed:@""]];
    CGRect buttonSevenFrame = CGRectMake(0, 64*7, [_dropDown bounds].size.width, [_dropDown bounds].size.height);
    optionSeven = [[UIButton alloc]init];
    optionSeven.frame=buttonSevenFrame;
    optionSeven.contentEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 0);
    [optionSeven setBackgroundColor:[UIColor blackColor]];
    [optionSeven setTitle:@"Sunday" forState:UIControlStateNormal];
    optionSeven.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [optionSeven addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
    optionSeven.tag=6;
    [_dropDown addSubview:optionSeven];
    [_dropDown addSubview:imageSeven];
    
    [optionOne setAlpha:0.0];
    [optionTwo setAlpha:0.0];
    [optionThree setAlpha:0.0];
    [optionFour setAlpha:0.0];
    [optionFive setAlpha:0.0];
    [optionSix setAlpha:0.0];
    [optionSeven setAlpha:0.0];
    [imageOne setAlpha:0.0];
    [imageTwo setAlpha:0.0];
    [imageThree setAlpha:0.0];
    [imageFour setAlpha:0.0];
    [imageFive setAlpha:0.0];
    [imageSix setAlpha:0.0];
    [imageSeven setAlpha:0.0];
    [self.view insertSubview:_dropDown aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dropDown attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}


-(IBAction)ListDroped:(id)sender{
    if(!_isDroped){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y + 64*8, CGRectGetWidth(initialTableViewFrame), CGRectGetHeight(initialTableViewFrame));
            [self setButtonTitle];
            [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect openedListFrame = CGRectMake(0, 14, [[UIScreen mainScreen] bounds].size.width, 64*8);
                [_dropDown setFrame:openedListFrame];
                _isDroped = YES;
                [optionOne setAlpha:1.0];
                [optionTwo setAlpha:1.0];
                [optionThree setAlpha:1.0];
                [optionFour setAlpha:1.0];
                [optionFive setAlpha:1.0];
                [optionSix setAlpha:1.0];
                [optionSeven setAlpha:1.0];
                [imageOne setAlpha:1.0];
                [imageTwo setAlpha:1.0];
                [imageThree setAlpha:1.0];
                [imageFour setAlpha:1.0];
                [imageFive setAlpha:1.0];
                [imageSix setAlpha:1.0];
                [imageSeven setAlpha:1.0];
            }];
        }];
    } else{
        [UIView animateWithDuration:0.05 animations:^{
            [optionOne setAlpha:0.0];
            [optionTwo setAlpha:0.0];
            [optionThree setAlpha:0.0];
            [optionFour setAlpha:0.0];
            [optionFive setAlpha:0.0];
            [optionSix setAlpha:0.0];
            [optionSeven setAlpha:0.0];
            [imageOne setAlpha:0.0];
            [imageTwo setAlpha:0.0];
            [imageThree setAlpha:0.0];
            [imageFour setAlpha:0.0];
            [imageFive setAlpha:0.0];
            [imageSix setAlpha:0.0];
            [imageSeven setAlpha:0.0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect dropDownFrame =CGRectMake(0, 14, [[UIScreen mainScreen] bounds].size.width, 64);
                [_dropDown setFrame:dropDownFrame];
                [self setButtonTitle];
                [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
                
                self.tableView.frame = initialTableViewFrame;
                _isDroped = NO;
            }];
        }];
    }
}

-(void)setDropDownTitleButton{
    if(_isDroped){
        [self setButtonTitle];
        [dropDownImage setImage:[UIImage imageNamed:@"DropDownUp"]];
        
    }
    else{
        [self setButtonTitle];
        [dropDownImage setImage:[UIImage imageNamed:@"DropDownDown"]];
        
    }
}

-(IBAction)optionPressed:(UIButton*)sender{
    
    if(sender.tag==0){
        [self setDropDownTitleButton];
        _selectedButton=0;
        _dropDownTitle=@"Monday";
    }
    else if(sender.tag==1){
        [self setDropDownTitleButton];
        _selectedButton=1;
        _dropDownTitle=@"Tuesday";
    }
    else if(sender.tag==2){
        [self setDropDownTitleButton];
        _selectedButton=2;
        _dropDownTitle=@"Wednesday";
    }
    else if(sender.tag==3){
        [self setDropDownTitleButton];
        _selectedButton=3;
        _dropDownTitle=@"Thursday";
    }
    else if(sender.tag==4){
        [self setDropDownTitleButton];
        _selectedButton=4;
        _dropDownTitle=@"Friday";
    }
    else if(sender.tag==5){
        [self setDropDownTitleButton];
        _selectedButton=5;
        _dropDownTitle=@"Saturday";
    }
    else if(sender.tag==6){
        [self setDropDownTitleButton];
        _selectedButton=6;
        _dropDownTitle=@"Sunday";
    }
    
    [self ListDroped:sender];
    [self setupButtons];
    [self setupShowingMovies];
    [self.tableView reloadData];
}

-(void)setupButtons{
    NSString *selectedButton =@"DropDownSelected";
    NSString *notSelectedButton=@"";
    NSString *buttonOne;
    NSString *buttonTwo;
    NSString *buttonThree;
    NSString *buttonFour;
    NSString *buttonFive;
    NSString *buttonSix;
    NSString *buttonSeven;
    
    if(_selectedButton ==0){
        buttonOne=selectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=notSelectedButton;
        
    }
    else if(_selectedButton ==1){
        buttonOne=notSelectedButton;
        buttonTwo=selectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=notSelectedButton;
    }
    else if(_selectedButton ==2){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=selectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=notSelectedButton;
    }
    else if(_selectedButton ==3){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=selectedButton;
        buttonFive=notSelectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=notSelectedButton;
    }
    else if(_selectedButton ==4){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=selectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=notSelectedButton;
    }
    else if(_selectedButton ==5){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
        buttonSix=selectedButton;
        buttonSeven=notSelectedButton;
    }
    else if(_selectedButton ==6){
        buttonOne=notSelectedButton;
        buttonTwo=notSelectedButton;
        buttonThree=notSelectedButton;
        buttonFour=notSelectedButton;
        buttonFive=notSelectedButton;
        buttonSix=notSelectedButton;
        buttonSeven=selectedButton;
    }
    [imageOne setImage:[UIImage imageNamed:buttonOne]];
    [imageTwo setImage:[UIImage imageNamed:buttonTwo]];
    [imageThree setImage:[UIImage imageNamed:buttonThree]];
    [imageFour setImage:[UIImage imageNamed:buttonFour]];
    [imageFive setImage:[UIImage imageNamed:buttonFive]];
    [imageSix setImage:[UIImage imageNamed:buttonSix]];
    [imageSeven setImage:[UIImage imageNamed:buttonSeven]];
}


//#setup allMovies

-(void)setupShowingMovies{
    _showingMovie = [[NSMutableArray alloc] init];
    for(Movie *mv in _allMovies){
        switch (_selectedButton) {
            case 0:{
                for(int i=0; i<[mv.playingDays count];i++){
                    if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Monday"]){
                        [_showingMovie addObject:mv];
                    }}}
                break;
            case 1:{
                for(int i=0; i<[mv.playingDays count];i++){
                    if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Tuesday"]){
                        [_showingMovie addObject:mv];
                    }}}
                break;
            case 2:{
                for(int i=0; i<[mv.playingDays count];i++){
                    if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Wednesday"]){
                        [_showingMovie addObject:mv];
                    }}}
                break;
            case 3:{for(int i=0; i<[mv.playingDays count];i++){
                if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Thursday"]){
                    [_showingMovie addObject:mv];
                }}}
                break;
            case 4:{for(int i=0; i<[mv.playingDays count];i++){
                if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Friday"]){
                    [_showingMovie addObject:mv];
                }}}
                break;
            case 5:{for(int i=0; i<[mv.playingDays count];i++){
                if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Saturday"]){
                    [_showingMovie addObject:mv];
                }}}
                break;
            case 6:{for(int i=0; i<[mv.playingDays count];i++){
                if( [[[mv.playingDays objectAtIndex:i] playingDay] isEqualToString:@"Sunday"]){
                    [_showingMovie addObject:mv];
                }}}
                break;
                
            default:
                break;
        }
    }
}

//#setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_showingMovie count] > 0? [_showingMovie count] :0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CinemaCell *cell = (CinemaCell*)[tableView dequeueReusableCellWithIdentifier:cinemaCellIdentifier forIndexPath:indexPath];
    [cell setupWithMovie:[_showingMovie objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([UIScreen mainScreen].bounds.size.height-150)/3;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FirebaseDetailViewController *firebaseDetails = (FirebaseDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FirebaseDetailController"];
    firebaseDetails.singleMovie = [_showingMovie objectAtIndex:indexPath.row];
    switch (_selectedButton) {
        case 0:{
            for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
                if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Monday"]){
                    firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
                }}}
            break;
        case 1:{
            for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
                if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Tuesday"]){
                    firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
                }}}
            break;
        case 2:{
            for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
                if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Wednesday"]){
                    firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
                }}}
            break;
        case 3:{for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
            if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Thursday"]){
                firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
            }}}
            break;
        case 4:{for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
            if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Friday"]){
                firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
            }}}
            break;
        case 5:{for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
            if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Saturday"]){
                firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
            }}}
            break;
        case 6:{for(int i=0; i<[[_showingMovie objectAtIndex:indexPath.row].playingDays count];i++){
            if( [[[[_showingMovie objectAtIndex:indexPath.row].playingDays objectAtIndex:i] playingDay] isEqualToString:@"Sunday"]){
                firebaseDetails.indexPlayDay =[NSNumber numberWithInt:i];
            }}}
            break;
            
        default:
            break;
    }

    [self.navigationController pushViewController:firebaseDetails animated:YES];
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
