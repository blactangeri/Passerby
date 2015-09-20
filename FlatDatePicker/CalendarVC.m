//
//  CalendarVC.m
//  Passerby
//
//  Created by KING J on 9/20/15.
//  Copyright © 2015 James Dong. All rights reserved.
//

#import "CalendarVC.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"
#import "ListEntries.h"

@interface CalendarVC() <PDTSimpleCalendarViewDelegate>

@end

@implementation CalendarVC

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	
	
}


- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date {
	
}

@end
