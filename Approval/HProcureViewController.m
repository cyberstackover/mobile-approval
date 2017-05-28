//
//  HProcureViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/17/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "HProcureViewController.h"
#import "MenuViewCell.h"

@interface HProcureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *menuImages, *menuTitles;
}

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@end

@implementation HProcureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuImages = @[@"ic_pr",@"ic_po",@"ic_tax",@"ic_bos",@"ic_notif",@"ic_contract",@"ic_reservation"];
    menuTitles = @[@"Purchase Requsition",@"Purchase Order",@"TAX Wapu",@"BOS",@"PM Notif",@"PO Contract",@"Reservation"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return menuImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    Goal *item = [items objectAtIndex:indexPath.row];
//    
//    NSString *identifier = [NSString stringWithFormat:@"Identifier_%d-%d-%d", (int)indexPath.section, (int)indexPath.row, (int)indexPath.item];
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    MenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.img setImage:[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]]];
    cell.lb.text = [menuTitles objectAtIndex:indexPath.row];
    
    cell.bg.layer.cornerRadius = 10.0f;
    
    /*
    int w = 180;
    int wi = 80;
    int s = (w-wi)/2/2;
    
    GoalView *gv = [[GoalView alloc] initWithFrame:(CGRect){0,0,180,180}];
    
    if (IS_IPHONE_5) {
        gv = [[GoalView alloc] initWithFrame:(CGRect){0,0,150,150}];
    }
    
    gv.backgroundColor = [UIColor redColor];
    [gv draw:item];
    [cell addSubview:gv];
    */
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPR" object:nil];
    }
    else if (indexPath.row==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPO" object:nil];
    }
    else if (indexPath.row==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTax" object:nil];
    }
    else if (indexPath.row==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBOS" object:nil];
    }
    else if (indexPath.row==4) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPMNotif" object:nil];
    }
    else if (indexPath.row==5) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPOContract" object:nil];
    }
    else if (indexPath.row==6) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showReservation" object:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //if (IS_IPHONE_5) {
    //    return CGSizeMake(150.f, 150.f);
    //}
    
    return CGSizeMake(160.f, 130.f);
//    return CGSizeMake(180.f, 180.f);
    
    
    
    
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize s = CGSizeMake(0, 0);
    NSLog(@"referenceSizeForHeaderInSection");
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"infoGoal"] isEqualToString:@"N"]) {
        s = CGSizeMake(0, 0);
        NSLog(@"referenceSizeForHeaderInSection 0");
    }
    else {
        
        if (IS_IPHONE_6) {
            s = CGSizeMake(0, 114);
            NSLog(@"referenceSizeForHeaderInSection 114");
        }
        else if (IS_IPHONE_6P ) {
            s = CGSizeMake(0, 114);
        }
        else if (IS_IPHONE_5 ) {
            s = CGSizeMake(0, 103);
        }
    }
    
    //if (section==0) return CGSizeMake( 0,0 );
    
    return s;
}
*/


@end
