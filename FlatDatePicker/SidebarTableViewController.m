#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "PhotoViewController.h"
#import "ViewController.h"
#import "ListEntries.h"
#import "DetailViewController.h"

@interface SidebarTableViewController ()

@end


UIColor *white;
UIColor *red;
UIColor *dark;
UIColor *light;

@implementation SidebarTableViewController {
    NSArray *menuItems;
    NSArray *cellImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    white = [UIColor whiteColor];
    red = [UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0];
    dark = [UIColor colorWithRed:34.0 / 255.0 green:34.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    light = [UIColor colorWithRed:58.0 / 255.0 green:58.0 / 255.0 blue:58.0 / 255.0 alpha:1.0];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor blackColor];
    
    menuItems = @[@"today", @"bucket list", @"reset birthday"];

    UIImage *star = [UIImage imageNamed:@"star.png"];
    UIImage *clock = [UIImage imageNamed:@"clock.png"];
    UIImage *settings = [UIImage imageNamed:@"settings.png"];
    
    cellImages = @[star, clock, settings];
    
    [self setHeader];
}

- (void)setHeader
{
    CGFloat h = 0.0;
    
    for (int i = 0; i < [self numberOfSectionsInTableView:self.tableView]; ++i) {
        for (int j = 0; j < [self tableView:self.tableView numberOfRowsInSection:i]; ++j) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            h += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        }
    }
    
    CGFloat ret = (self.tableView.bounds.size.height - h) / 2;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, ret)];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuItems objectAtIndex:indexPath.row] forIndexPath:indexPath];
    cell.textLabel.text = [[menuItems objectAtIndex:indexPath.row] uppercaseString];

    UIImage *img = [cellImages objectAtIndex:indexPath.row];
    cell.imageView.image = img;
    CGFloat w = 20.0 / img.size.width;
    CGFloat h = 20.0 / img.size.height;
    cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, w, h);
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = light;
    
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"din-light" size:16];
}

- (void)tableView:(nonnull UITableView *)tableView didHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = red;
}

- (void)tableView:(nonnull UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = white;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"gotoPhoto" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
