//
//  HomeViewController.m
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 2/15/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "HomeViewController.h"
#import "HHomeViewController.h"
#import "HProcureViewController.h"
#import "HHrisViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface HomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sc;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@end

@implementation HomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPR)
                                                 name:@"showPR" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPO)
                                                 name:@"showPO" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTax)
                                                 name:@"showTax" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBOS)
                                                 name:@"showBOS" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPMNotif)
                                                 name:@"showPMNotif" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPOContract)
                                                 name:@"showPOContract" object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTravel)
                                                 name:@"showTravel" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOvertime)
                                                 name:@"showOvertime" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSubstitusion)
                                                 name:@"showSubstitusion" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLeave)
                                                 name:@"showLeave" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLSO)
                                                 name:@"showLSO" object:nil];

    
    self.title = @"SMI Approval";
    
    [_sc addTarget:self action:@selector(scTapped) forControlEvents:UIControlEventValueChanged];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    _sv.bounces = NO;
    _sv.pagingEnabled = YES;
    _sv.contentSize = CGSizeMake(w * 3, 1);
    _sv.delegate = self;
    _sv.backgroundColor = [UIColor redColor];
    
    [self addHome];
    [self addProcure];
    [self addHris];
    
    UIBarButtonItem *btnLogout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = btnLogout;
}

- (void)logout {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"SIM Approval"
                                message:@"Apakah anda ingin keluar"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ya"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self doLogout];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Tidak"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doLogout {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"login"];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:vc];
}

- (void)addHome {
    NSLog(@"addHome");
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    
    NSLog(@"h: %f",h);
    
    if (IS_IPHONE_6) {
        
        h = 667; //667 vs 602
    }
    else if (IS_IPHONE_6P) {
        h = 736; //736 vs 671
    }
    else {
        
    }
    
    UIView *v = [[UIView alloc] initWithFrame:(CGRect){0,0,w,h}];
    v.backgroundColor = [UIColor redColor];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"hhome"];
    
    [self addChildViewController:vc];
    
    if (IS_IPHONE_6) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else if (IS_IPHONE_6P) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else {
        // iphone 5
        
        //CGFloat w = 210;
        //CGFloat h = (20*7) + 60;
        
    }
    
    [v addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    [_sv addSubview:v];
}

- (void)addProcure {
    NSLog(@"addProcure");
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    
    NSLog(@"h: %f",h);
    
    if (IS_IPHONE_6) {
        
        h = 667; //667 vs 602
    }
    else if (IS_IPHONE_6P) {
        h = 736; //736 vs 671
    }
    else {
        
    }
    
    UIView *v = [[UIView alloc] initWithFrame:(CGRect){w,0,w,h}];
    v.backgroundColor = [UIColor redColor];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HProcureViewController *vc = [sb instantiateViewControllerWithIdentifier:@"hprocure"];
    
    [self addChildViewController:vc];
    
    if (IS_IPHONE_6) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else if (IS_IPHONE_6P) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else {
        // iphone 5
        
        //CGFloat w = 210;
        //CGFloat h = (20*7) + 60;
        
    }
    
    [v addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    [_sv addSubview:v];
}

- (void)addHris {
    NSLog(@"addHris");
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    
    NSLog(@"h: %f",h);
    
    if (IS_IPHONE_6) {
        
        h = 667; //667 vs 602
    }
    else if (IS_IPHONE_6P) {
        h = 736; //736 vs 671
    }
    else {
        
    }
    
    UIView *v = [[UIView alloc] initWithFrame:(CGRect){w*2,0,w,h}];
    v.backgroundColor = [UIColor redColor];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HHrisViewController *vc = [sb instantiateViewControllerWithIdentifier:@"hhris"];
    
    [self addChildViewController:vc];
    
    if (IS_IPHONE_6) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else if (IS_IPHONE_6P) {
        vc.view.frame = (CGRect){0,0,w,h};
    }
    else {
        // iphone 5
        
        //CGFloat w = 210;
        //CGFloat h = (20*7) + 60;
        
    }
    
    [v addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    [_sv addSubview:v];
}

- (void)scTapped {
    if (_sc.selectedSegmentIndex==0) {
        [self showHome];
    }
    else if (_sc.selectedSegmentIndex==1) {
        [self showProcure];
    }
    else {
        [self showHris];
    }
}

- (void)showHome {
    NSLog(@"home");
    [_sv setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)showProcure {
    NSLog(@"procure");
    CGFloat w = self.view.bounds.size.width;
    [_sv setContentOffset:CGPointMake(w,0) animated:YES];
}

- (void)showHris {
    NSLog(@"hris");
    CGFloat w = self.view.bounds.size.width;
    [_sv setContentOffset:CGPointMake(w*2,0) animated:YES];
}

- (void)showPR {
    NSLog(@"pr");
    [self performSegueWithIdentifier:@"pr" sender:nil];
}

- (void)showPO {
    NSLog(@"po");
    [self performSegueWithIdentifier:@"po" sender:nil];
}

- (void)showTax {
    NSLog(@"tax");
    [self performSegueWithIdentifier:@"tax" sender:nil];
}

- (void)showBOS {
    NSLog(@"bos");
    [self performSegueWithIdentifier:@"bos" sender:nil];
}

- (void)showPMNotif {
    NSLog(@"pmnotif");
    [self performSegueWithIdentifier:@"pmnotif" sender:nil];
}

- (void)showPOContract {
    NSLog(@"pocontract");
    [self performSegueWithIdentifier:@"pocontract" sender:nil];
}

- (void)showTravel {
    [self performSegueWithIdentifier:@"travel" sender:nil];
}

- (void)showOvertime {
    [self performSegueWithIdentifier:@"overtime" sender:nil];
}

- (void)showSubstitusion {
    [self performSegueWithIdentifier:@"substitusion" sender:nil];
}

- (void)showLeave {
    [self performSegueWithIdentifier:@"leave" sender:nil];
}

- (void)showLSO {
    [self performSegueWithIdentifier:@"lso" sender:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.4];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    int currPage = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    NSLog(@"currPage %d",currPage);
    _sc.selectedSegmentIndex = currPage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
