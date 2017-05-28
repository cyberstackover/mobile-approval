//
//  ReservationViewCell.h
//  Approval
//
//  Created by ryanthe on 5/28/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nominal;

@end
