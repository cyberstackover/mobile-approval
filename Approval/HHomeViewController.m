//
//  HHomeViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/17/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "HHomeViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@interface HHomeViewController ()


@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

// The data source for the table view
@property (strong, nonatomic) NSMutableArray *todoItems;

@property (strong, nonatomic) EKCalendar *calendar;

@property (copy, nonatomic) NSArray *events;

@end

@implementation HHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateAuthorizationStatusToAccessEventStore];
    [self fetchEvents];
}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Event." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak HHomeViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    //[weakSelf.tableView reloadData];
                                                });
                                            }];
            break;
        }
    }
}

- (void)fetchEvents {
    if (self.isAccessToEventStoreGranted) {
        
        _eventStore = [[EKEventStore alloc] init];
        
        NSDate *start = [NSDate dateWithTimeIntervalSinceNow:-3600*24];
        NSDate *finish = [NSDate dateWithTimeIntervalSinceNow:3600*24];
        
        // use Dictionary for remove duplicates produced by events covered more one year segment
        NSMutableDictionary *eventsDict = [NSMutableDictionary dictionaryWithCapacity:1024];
        
        NSDate* currentStart = [NSDate dateWithTimeInterval:0 sinceDate:start];
        
        int seconds_in_year = 60*60*24*365;
        
        // enumerate events by one year segment because iOS do not support predicate longer than 4 year !
        while ([currentStart compare:finish] == NSOrderedAscending) {
            
            NSDate* currentFinish = [NSDate dateWithTimeInterval:seconds_in_year sinceDate:currentStart];
            
            if ([currentFinish compare:finish] == NSOrderedDescending) {
                currentFinish = [NSDate dateWithTimeInterval:0 sinceDate:finish];
            }
            NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:currentStart endDate:currentFinish calendars:nil];
            [_eventStore enumerateEventsMatchingPredicate:predicate
                                              usingBlock:^(EKEvent *event, BOOL *stop) {
                                                  
                                                  if (event) {
                                                      [eventsDict setObject:event forKey:event.eventIdentifier];
                                                  }
                                                  
                                              }];       
            currentStart = [NSDate dateWithTimeInterval:(seconds_in_year + 1) sinceDate:currentStart];
            
        }
        
        NSArray *events = [eventsDict allValues];
        
        NSLog(@"events: %@",events);
    }
}

@end
