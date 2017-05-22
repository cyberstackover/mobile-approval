//
//  TaxViewCell.h
//  Approval
//
//  Created by Ryan Fabella on 3/15/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
