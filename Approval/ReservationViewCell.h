//
//  ReservationViewCell.h
//  Approval
//
//  Created by ryanthe on 5/28/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title; //no_reservasi
@property (weak, nonatomic) IBOutlet UILabel *detail; //material_description
@property (weak, nonatomic) IBOutlet UILabel *nominal; //price_realease

/*
 "material_description" = "SPAREPART TEST";
 "material_number" = "623-600001";
 "mrp_controller" = 203;
 "no_reservasi" = 51566186;
 "price_realease" = "          103101601";
 quantity = "101000.000";
 "quantity_realease" = 100981;
 */
@end
