
#import "ResetViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface ResetViewController ()

@end

@implementation ResetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday";
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    
    [self.flatDatePicker show2];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    UIImage *cancelImg = [[UIImage imageNamed:@"cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cancelButton setImage:cancelImg forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 0, 18, 18)];
    cancelButton.tintColor = [UIColor grayColor];
    [cancelButton addTarget:self action:@selector(cancelReset) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = lbbi;
}

- (void)cancelReset
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:@"Did cancelled !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"dob"];
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *swr = [mainSb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:swr animated:YES completion:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
