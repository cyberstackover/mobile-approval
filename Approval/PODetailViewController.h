//
//  PODetailViewController.h
//  Approval
//
//  Created by Ryan Fabella on 3/6/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PODetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *list;
}

@property (weak, nonatomic) IBOutlet UILabel *ponum;
@property (weak, nonatomic) IBOutlet UILabel *vendor;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property NSDictionary *data;

- (IBAction)btnTapped:(id)sender;

@end
