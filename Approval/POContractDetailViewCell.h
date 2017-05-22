//
//  POContractDetailViewCell.h
//  Approval
//
//  Created by Ryan Fabella on 2/23/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POContractDetailViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *po;
@property (weak, nonatomic) IBOutlet UILabel *material;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UILabel *date;


@end
