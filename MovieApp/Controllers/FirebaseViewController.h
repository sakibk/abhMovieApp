//
//  FirebaseViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirebaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
