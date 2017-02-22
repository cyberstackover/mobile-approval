//
//  PMNotifViewCell.h
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMNotifViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *tujuan;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
