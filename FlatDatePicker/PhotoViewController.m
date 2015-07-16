//
//  PhotoViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "PhotoViewController.h"
#import "SWRevealViewController.h"
#import "ListEntries.h"
#import "ListEntry.h"
#import "DetailViewController.h"

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *rbbi;
@end

@implementation PhotoViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)identifierComponents coder:(nonnull NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self setupBackground];
    
}

- (void)setupBackground
{
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ListEntries sharedEntries] allEntries].count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSArray *entries = [[ListEntries sharedEntries] allEntries];
    ListEntry *entry = entries[indexPath.row];
    
    cell.textLabel.text = entry.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    cell.detailTextLabel.text = [formatter stringFromDate:entry.dateToFulfill];
    
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *entries = [[ListEntries sharedEntries] allEntries];
    ListEntry *selectedEntry = [entries objectAtIndex:indexPath.row];
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.entry = selectedEntry;
    dvc.isNew = NO;
    
    
}

- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *entries = [[ListEntries sharedEntries] allEntries];
        ListEntry *entry = [entries objectAtIndex:indexPath.row];
        [[ListEntries sharedEntries] removeEntry:entry];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

- (void)addNewEntry
{
    
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"createNew2"]) {
        
    }
}

- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"din-light" size:20];
    cell.textLabel.textColor = [UIColor lightGrayColor];
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
