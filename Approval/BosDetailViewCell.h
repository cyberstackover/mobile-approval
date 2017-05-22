//
//  BosDetailViewCell.h
//  Approval
//
//  Created by Ryan Fabella on 3/15/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BosDetailViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pr;
@property (weak, nonatomic) IBOutlet UILabel *material;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
