//
//  PODetailViewCell.h
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 3/6/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PODetailViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *po;
@property (weak, nonatomic) IBOutlet UILabel *material;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
