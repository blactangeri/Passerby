//
//  DaysViewController.m
//  Passerby
//
//  Created by KING J on 9/19/15.
//  Copyright © 2015 James Dong. All rights reserved.
//

#import "DaysViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface DaysViewController() <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end

@implementation DaysViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"daycell"];
	
	self.tableView.emptyDataSetDelegate = self;
	self.tableView.emptyDataSetSource = self;
	
	[self setBackground];
}

- (void)setBackground {
	
}


@end
