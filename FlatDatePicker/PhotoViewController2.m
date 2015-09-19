//
//  PhotoViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "PhotoViewController2.h"
#import "SWRevealViewController.h"
#import "ListEntries.h"
#import "ListEntry.h"
#import "DetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface PhotoViewController2 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *rbbi;

@end

@implementation PhotoViewController2

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)identifierComponents coder:(nonnull NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self setupBackground];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    if ([[ListEntries sharedEntries] allEntries2].count > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
    self.navigationController.navigationBar.translucent = NO;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)setupBackground
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIButton *delBtn = [[UIButton alloc] init];
    UIImage *delImg = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [delBtn setImage:delImg forState:UIControlStateNormal];
    [delBtn setFrame:CGRectMake(0, 0, 25, 25)];
    delBtn.tintColor = [UIColor lightGrayColor];
    [delBtn addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    if ([[ListEntries sharedEntries] allEntries2].count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    //[self.navigationItem setTitle:@"PASSER'S LIST"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ListEntries sharedEntries] allEntries2].count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSArray *entries = [[ListEntries sharedEntries] allEntries2];
    ListEntry *entry = entries[indexPath.row];
    
    cell.textLabel.text = entry.desc;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [formatter stringFromDate:entry.dateCompleted];
    cell.detailTextLabel.text = dateString;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:view];
    
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *entries = [[ListEntries sharedEntries] allEntries2];
	DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.isNew = NO;
    dvc.isComplete = YES;
    dvc.entry = [entries objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"din-light" size:22];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"din-light" size:15];
}


- (IBAction)createNew:(id)sender
{
    DetailViewController *dvc = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dvc.isNew = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dvc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"save.png"];
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"GET STARTED BY CREATING A NEW ITEM";
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:15], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text.lowercaseString attributes:dict];}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"NO GOAL COMPLETED YET";
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:23], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:dict];
}

-  (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.view.backgroundColor;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointZero;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
    
}

- (void)clearAll
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear All?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:
                         ^(UIAlertAction *action){
                             [[ListEntries sharedEntries] removeAll];
                             [self.tableView reloadData];
                             [self.navigationItem.rightBarButtonItem setEnabled:NO];
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
