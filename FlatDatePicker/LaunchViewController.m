//
//  LaunchViewController.m
//  Passerby
//
//  Created by KING J on 7/11/15.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import "LaunchViewController.h"
#import "FBShimmering/FBShimmeringView.h"


@interface LaunchViewController ()

@end

@implementation LaunchViewController
{
    FBShimmeringView *_shimmeringView;
    UILabel *titleLabel;
    UILabel *bottomLabel;
    UILabel *_logoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:40.0/255.0 blue:34.0/255.0 alpha:1.0];
    
    /*bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    bottomLabel.text = @"Designed by James Dong in New York City // Copyright © 2015 James Dong. All rights reserved.";
    bottomLabel.font = [UIFont fontWithName:@"din-light" size:18];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomLabel];
    
    _shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.frame];
    _shimmeringView.shimmering = YES;
    [self.view addSubview:_shimmeringView];

    titleLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    titleLabel.text = @"PASSERBY";
    titleLabel.font = [UIFont fontWithName:@"din-light" size:32];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = titleLabel; */
    
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    shimmeringView.shimmering = YES;

    [self.view addSubview:shimmeringView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];

    loadingLabel.text = NSLocalizedString(@"Shimmer", nil);
    shimmeringView.contentView = loadingLabel;
    
    // Start shimmering.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
