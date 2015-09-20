
#import "ResetViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "RKDropdownAlert.h"

@interface ResetViewController ()

@end

@implementation ResetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setBackground];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self setBackground];
}

- (void)setBackground
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    
    [[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"din-light" size:24]];
    [[SSFlatDatePicker appearance] setGradientColor:[UIColor blackColor]];
    [[SSFlatDatePicker appearance] setTextColor:[UIColor whiteColor]];
    
    self.flatDatePicker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, (h - h/3.0) / 2.0,  w, h / 3.0)];
	self.flatDatePicker.datePickerMode = SSFlatDatePickerModeDate;
    [self.view addSubview:self.flatDatePicker];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _flatDatePicker.frame.origin.y / 2.0, w, 44)];
    lbl.text = @"Reset birthday";
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"din-light" size:24];
    [self.view addSubview:lbl];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, h - 44, w, 44)];
    okBtn.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
    [okBtn setImage:[UIImage imageNamed:@"FlatDatePicker-Icon-Check.png"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(actionButtonValid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
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

- (void)actionButtonValid
{
	NSDate *now = [NSDate date];
	NSDate *birthday = [_flatDatePicker date];
	
	if ([now earlierDate: birthday] == now) {
		[RKDropdownAlert title:@"Set a valid date of birth" message:nil backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
		return;
	}
    [[NSUserDefaults standardUserDefaults] setObject:[_flatDatePicker date] forKey:@"dob"];
    
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	
}

#pragma mark - FlatDatePicker Delegate


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
