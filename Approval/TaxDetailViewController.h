//
//  TaxDetailViewController.h
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 3/10/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property NSDictionary *header;
@property NSArray *data;

@end
