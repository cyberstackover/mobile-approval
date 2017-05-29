//
//  ReservationDetailViewController.h
//  Approval
//
//  Created by dody on 5/29/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *list;
}

@property (weak, nonatomic) IBOutlet UILabel *reservasinum;
@property (weak, nonatomic) IBOutlet UILabel *plant;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property NSDictionary *data;

- (IBAction)btnTapped:(id)sender;

@end
