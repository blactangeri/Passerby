#import "PhotoViewController.h"
#import "ListEntries.h"
#import "ListEntry.h"
#import "DetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface PhotoViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation PhotoViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(nonnull NSArray *)identifierComponents coder:(nonnull NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self setupBackground];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)setupBackground
{
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
	self.navigationController.navigationBar.translucent = NO;
	
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
    [self.view setBackgroundColor:[UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0]];
	
	
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target: self action:@selector(createNew)];
	[rightBarButtonItem setTintColor:[UIColor lightGrayColor]];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem;
	
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
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSArray *entries = [[ListEntries sharedEntries] allEntries];
    ListEntry *entry = entries[indexPath.row];
	
    cell.textLabel.text = entry.desc;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [formatter stringFromDate:entry.dateToFulfill];
    cell.detailTextLabel.text = dateString;
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:view];
	
	NSDate *now = [NSDate date];
	
	if ([now laterDate:entry.dateToFulfill] == now) {
		NSDictionary *dict = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleThick],
							   NSStrikethroughColorAttributeName: [UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]
							   };
		NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:entry.desc attributes:dict];
		cell.textLabel.attributedText = str;
	}
    
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *entries = [[ListEntries sharedEntries] allEntries];
	DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.isNew = NO;
    dvc.entry = [entries objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}
/*
- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *entries = [[ListEntries sharedEntries] allEntries];
        ListEntry *entry = [entries objectAtIndex:indexPath.row];
        [[ListEntries sharedEntries] removeEntry:entry];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
*/
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    //cell.textLabel.font = [UIFont fontWithName:@"din-light" size:22];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"din-light" size:15];
}

- (void)tableView:(nonnull UITableView *)tableView willBeginEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)tableView:(nonnull UITableView *)tableView didEndEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
	[self.tableView reloadData];
}

- (void)createNew
{
	DetailViewController *dvc = [[DetailViewController alloc] init];
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
    return [UIImage imageNamed:@"list.png"];
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"GET STARTED BY CREATING A NEW ITEM";
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:15], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text.lowercaseString attributes:dict];}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"EMPTY LIST";
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:24], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
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


@end
