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

@import Firebase;

@interface FirebaseViewController ()
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *comments;
@property (strong, nonatomic) FIRDatabaseReference *postRef;
@property (strong, nonatomic) FIRDatabaseReference *commentsRef;
@property(strong, nonatomic) NSMutableArray<Movie*> *allMovies;

@end

@implementation FirebaseViewController{
     FIRDatabaseHandle _refHandle;
    UIButton *butt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    self.postRef = [ref child:@"Movies"];
    self.commentsRef = [ref child:@"Movies"];
    self.comments =[[NSMutableArray alloc] init];
    _allMovies = [[NSMutableArray alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"CinemaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cinemaCellIdentifier];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self setupButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_commentsRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         [self.comments addObject:snapshot];
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

- (void)viewWillDisappear:(BOOL)animated {
    [self.postRef removeObserverWithHandle:_refHandle];
    [self.commentsRef removeAllObservers];
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_comments count] > 0? [_comments count] :0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CinemaCell *cell = (CinemaCell*)[tableView dequeueReusableCellWithIdentifier:cinemaCellIdentifier forIndexPath:indexPath];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
