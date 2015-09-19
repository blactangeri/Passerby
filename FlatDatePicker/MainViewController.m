
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "PSAnalogClockView.h"
#import "LifeViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) PSAnalogClockView *clock;
@property (nonatomic, strong) UILabel *dobLabel;
@property (nonatomic, strong) NSMutableArray *statsLabels;
@property (nonatomic, strong) UIButton *lifeButton;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) UILabel *lbl6;
@end

double age;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
    NSTimeInterval interval = [_dob timeIntervalSinceNow];
    age = (double)interval / (365 * 24 * 3600);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    UIButton *userButton = [[UIButton alloc] init];
    UIImage *userImg = [[UIImage imageNamed:@"user.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:userImg forState:UIControlStateNormal];
    [userButton setFrame:CGRectMake(0, 0, 28, 28)];
    userButton.tintColor = [UIColor lightGrayColor];
    [userButton addTarget:self action:@selector(gotoLife) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    //[self.navigationController navigationBar].tintColor = [UIColor lightGrayColor];

    [self createClock];
    [self addDobLabel];
    //[self addButton];
    [self addStatsLabels];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}


- (void)gotoLife
{
    [self performSegueWithIdentifier:@"gotoLife" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createClock
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat clockSize = screenHeight * 0.315;
    
    self.clock = [[PSAnalogClockView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width - clockSize) / 2,
                                                                     [[UIScreen mainScreen] bounds].size.height * 0.09, clockSize, clockSize) andImages:[self clockImgs] withOptions:PSAnalogClockViewOptionClunkyHands];
    [self.view addSubview:self.clock];
    [self.clock start];
}

- (void)addDobLabel
{
    self.dobLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height / 2, [[UIScreen mainScreen] bounds].size.width, 24)];
    
    self.dobLabel.textColor = [UIColor grayColor];
    self.dobLabel.textAlignment = NSTextAlignmentCenter;
    self.dobLabel.font = [UIFont fontWithName:@"din-light" size:25];
    //NSString *currentTime = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
    self.dobLabel.numberOfLines = 0;

    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_dob];
    age = (double)interval / (365 * 24 * 3600);

    self.dobLabel.text = [NSString stringWithFormat:@"YOU ARE %.8f", age];
    [self.view addSubview:self.dobLabel];
}

- (void)updateLabel
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_dob];
    age = (double)interval / (365 * 24 * 3600);
    self.dobLabel.text = [NSString stringWithFormat:@"YOU ARE %.8f", age];
    _dobLabel.textColor = [UIColor grayColor];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMinute;
    NSDateComponents *comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    _lbl6.text = [NSString stringWithFormat:@"%ld\rminutes", (long)[comp minute]];
    
}

/*
 - (void)addButton
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width * 0.67;
    CGFloat h = 44;
    CGFloat x = ([[UIScreen mainScreen] bounds].size.width- w) / 2.0;
    CGFloat y = ([[UIScreen mainScreen] bounds].size.height - h) * 0.98;

    DeformationButton *deformationBtn = [[DeformationButton alloc] initWithFrame:CGRectMake(x, y, w, h) withColor:[UIColor grayColor]];
    [self.view addSubview:deformationBtn];
    
    [deformationBtn.forDisplayButton setTitle:@"Your life on a paper" forState:UIControlStateNormal];
    [deformationBtn.forDisplayButton.titleLabel setFont:[UIFont fontWithName:@"din-light" size:18]];
    [deformationBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deformationBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [deformationBtn addTarget:self action:@selector(gotoLife) forControlEvents:UIControlEventTouchUpInside];
}
 */

- (void)changeBackground
{
    [_lifeButton setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
}

- (NSDictionary *)clockImgs
{
    return @{
             PSAnalogClockViewClockFace: [UIImage imageNamed:@"clock_face"],
             PSAnalogClockViewCenterCap: [UIImage imageNamed:@"clock_centre_point"],
             PSAnalogClockViewHourHand: [UIImage imageNamed:@"clock_hour_hand"],
             PSAnalogClockViewMinuteHand: [UIImage imageNamed:@"clock_minute_hand"],
             PSAnalogClockViewSecondHand: [UIImage imageNamed:@"clock_second_hand"]
             };
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoLife"]) {
        LifeViewController *lvc = [segue destinationViewController];
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitMonth;
        NSDateComponents *comp = [sysCalendar components:unit fromDate:_dob toDate:[NSDate date] options:NSCalendarWrapComponents];
        
        [lvc setMonth:[comp month]];
        [lvc setDob:_dob];
    }
}

- (void)addStatsLabels
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width * 0.85 / 3.0;
    CGFloat h = 44;
    CGFloat x = ([[UIScreen mainScreen] bounds].size.width - 3 * w) / 2.0;
    CGFloat y = ([[UIScreen mainScreen] bounds].size.height) * 0.7;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height * 0.65, [[UIScreen mainScreen] bounds].size.width, 15)];
    lbl.text = @"YOU HAVE LIVED";
    lbl.textColor = [UIColor grayColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"din-light" size:15];
    [self.view addSubview:lbl];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    lbl1.textColor = [UIColor grayColor];
    lbl1.text = [NSString stringWithFormat:@"%ld\ryears", (long)[comp year]];
    [self.view addSubview:lbl1];
    lbl1.layer.borderColor = [[UIColor grayColor] CGColor];
    lbl1.layer.borderWidth = 0.5;
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.font = [UIFont fontWithName:@"din-light" size:15];
    lbl1.numberOfLines = 0;
    [self.view addSubview:lbl1];
    
    unit = NSCalendarUnitMonth;
    comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(x + w, y, w, h)];
    lbl2.textColor = [UIColor grayColor];
    lbl2.text = [NSString stringWithFormat:@"%ld\rmonths", (long)[comp month]];
    [self.view addSubview:lbl2];
    lbl2.layer.borderColor = [[UIColor grayColor] CGColor];
    lbl2.layer.borderWidth = 0.5;
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.font = [UIFont fontWithName:@"din-light" size:15];
    lbl2.numberOfLines = 0;
    [self.view addSubview:lbl2];
    
    unit = NSCalendarUnitDay;
    comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(x + 2 * w, y, w, h)];
    lbl3.textColor = [UIColor grayColor];
    lbl3.text = [NSString stringWithFormat:@"%ld\rweeks", (long)[comp day] / 7];
    [self.view addSubview:lbl3];
    lbl3.layer.borderColor = [[UIColor grayColor] CGColor];
    lbl3.layer.borderWidth = 0.5;
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.font = [UIFont fontWithName:@"din-light" size:15];
    lbl3.numberOfLines = 0;
    [self.view addSubview:lbl3];
    
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(x, y + h, w, h)];
    lbl4.textColor = [UIColor grayColor];
    lbl4.text = [NSString stringWithFormat:@"%ld\rdays", (long)[comp day]];
    lbl4.layer.borderColor = [[UIColor grayColor] CGColor];
    lbl4.layer.borderWidth = 0.5;
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.font = [UIFont fontWithName:@"din-light" size:15];
    lbl4.numberOfLines = 0;
    [self.view addSubview:lbl4];
    
    unit = NSCalendarUnitHour;
    comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(x + w, y + h, w, h)];
    lbl5.textColor = [UIColor grayColor];
    lbl5.text = [NSString stringWithFormat:@"%ld\rhours", (long)[comp hour]];
    lbl5.layer.borderColor = [[UIColor grayColor] CGColor];
    lbl5.layer.borderWidth = 0.5;
    lbl5.textAlignment = NSTextAlignmentCenter;
    lbl5.font = [UIFont fontWithName:@"din-light" size:15];
    lbl5.numberOfLines = 0;
    [self.view addSubview:lbl5];
    
    unit = NSCalendarUnitMinute;
    comp = [cal components:unit fromDate:_dob toDate:[NSDate date] options:0];
    _lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(x + 2 * w, y + h, w, h)];
    _lbl6.textColor = [UIColor grayColor];
    _lbl6.text = [NSString stringWithFormat:@"%ld\rminutes", (long)[comp minute]];
    _lbl6.layer.borderColor = [[UIColor grayColor] CGColor];
    _lbl6.layer.borderWidth = 0.5;
    _lbl6.textAlignment = NSTextAlignmentCenter;
    _lbl6.font = [UIFont fontWithName:@"din-light" size:15];
    _lbl6.numberOfLines = 0;
    [self.view addSubview:_lbl6];
    /*
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0, w - 0.5, h - 0.5)];
    mask.backgroundColor = [UIColor grayColor];
    lbl.layer.mask = mask.layer;
    */
    
}


@end
