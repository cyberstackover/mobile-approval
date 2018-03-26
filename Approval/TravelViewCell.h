//
//  TravelViewCell.h
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UILabel *jenis;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *dest;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
