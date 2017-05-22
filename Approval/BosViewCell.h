//
//  BosViewCell.h
//  Approval
//
//  Created by Ryan Fabella on 3/10/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BosViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
//@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *comname;
@property (weak, nonatomic) IBOutlet UILabel *lifnr;
//@property (weak, nonatomic) IBOutlet UILabel *bukrs;
@property (weak, nonatomic) IBOutlet UILabel *bilno;

@end
