
#import "DetailViewController.h"
#import "ListEntries.h"
#import "ListEntry.h"
#import "UITextView+Placeholder.h"
#import "SSFlatDatePicker.h"
#import "RKDropdownAlert.h"

//#define offsetForKeyboard 80.0

@interface DetailViewController () <UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate,
                                    UIPopoverPresentationControllerDelegate, UIViewControllerRestoration, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *descField;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *ddlButton;
@property (nonatomic, strong) UIPopoverPresentationController *ppc;
@property (nonatomic, strong) SSFlatDatePicker *dp;
@property (nonatomic, strong) NSDate *dtc;
@end

CGFloat w;
CGFloat h;

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     w = [[UIScreen mainScreen] bounds].size.width;
     h = [[UIScreen mainScreen] bounds].size.height;
	
    [self setNavbarTitle];
    [self setupTextView];
    [self setDaysLabel];
	[self setupBackground];
	
	[self.navigationController.navigationBar setTitleTextAttributes:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIFont fontWithName:@"din-light" size:18], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil]];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:[UITextView class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:[UITextView class]];
    
    if (!_isNew && !_isComplete) {
        _entry.desc = self.descField.text;
        _entry.dateToFulfill = self.dtc;
    }
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)setupBackground
{
    self.view.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:24],
                                                                      NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    UIButton *userButton = [[UIButton alloc] init];
    
    if (_isNew) {
        UIImage *userImg = [[UIImage imageNamed:@"cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userButton setImage:userImg forState:UIControlStateNormal];
        [userButton setFrame:CGRectMake(0, 0, 20, 20)];
        userButton.tintColor = [UIColor lightGrayColor];
        [userButton addTarget:self action:@selector(cancelEditting) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:userButton];
        self.navigationItem.leftBarButtonItem = left;
        
        UIButton *saveButton = [[UIButton alloc] init];
        UIImage *saveImg = [[UIImage imageNamed:@"save.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [saveButton setImage:saveImg forState:UIControlStateNormal];
        [saveButton setFrame:CGRectMake(0, 0, 22, 22)];
        saveButton.tintColor = [UIColor lightGrayColor];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        self.navigationItem.rightBarButtonItem = right;
    }
    else {
        if (!_isComplete) {
            UIImage *userImg = [[UIImage imageNamed:@"edit.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [userButton setImage:userImg forState:UIControlStateNormal];
            [userButton setFrame:CGRectMake(0, 0, 23, 23)];
            userButton.tintColor = [UIColor lightGrayColor];
            [userButton addTarget:self action:@selector(editTask) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:userButton];
            self.navigationItem.rightBarButtonItem = right;
        }
        
        UIImage *backImg = [[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setImage:backImg forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, 20, 20)];
        backButton.tintColor = [UIColor lightGrayColor];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    if (!_isComplete) [self.view addGestureRecognizer:tap];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:_descField];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:[UITextView class]];
	
	if (!_isNew) {
		self.descField.text = _entry.desc;
		self.dtc = _entry.dateToFulfill;
	}
	
	[self.tabBarController.tabBar setHidden:YES];
}

- (void)setNavbarTitle
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	
    if (_isNew) [self.navigationItem setTitle:[formatter stringFromDate:[NSDate date]]];
    if (!_isNew && !_isComplete) [self.navigationItem setTitle:[formatter stringFromDate:_entry.dateToFulfill]];
	if (_isComplete) {
		[self.navigationItem setTitle: [NSString stringWithFormat:@"Completed on %@", [formatter stringFromDate:_entry.dateCompleted]]];
	}
}

- (void)setupTextView
{
	_descField = [[UITextView alloc] init];
    [_descField setFrame:CGRectMake(w * 0.1 / 2.0, h * 0.15, w * 0.9, h / 2.0 - h * 0.15)];
    _descField.delegate = self;
    [_descField setFont:[UIFont fontWithName:@"din-light" size:22]];
    [_descField setTextColor:[UIColor lightGrayColor]];
    [_descField setTextAlignment:NSTextAlignmentCenter];
    [_descField setText:@""];
	[_descField setBackgroundColor:[UIColor clearColor]];

    if (_isNew) {
        _descField.placeholder = @"What's the next big thing? Life is short. Don't let it pass you by. Do something that makes your life a story worth telling.";
        _descField.placeholderColor = [UIColor grayColor];
    }
    if (!_isNew && !_isComplete) {
        _descField.text = _entry.desc;
    }
	if (_isComplete) {
		[_descField setEditable:NO];
	}

	[self.view addSubview:_descField];
}

- (void)setDaysLabel
{
    CGFloat lw = w;
    //CGFloat y = (_descField.frame.origin.y + _descField.frame.size.height) + 20;
	CGFloat y = h / 2.0;

	if (_isNew) {
		_ddlButton = [[UIButton alloc] init];
		_ddlButton.frame = CGRectMake(w / 4.0, y, w / 2.0, 44);
		_ddlButton.titleLabel.font = [UIFont fontWithName:@"din-light" size:20];
		[_ddlButton setTitleColor:[UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0] forState:UIControlStateNormal];
		_ddlButton.titleLabel.textAlignment = NSTextAlignmentCenter;
		_ddlButton.layer.borderWidth = 0;
		[_ddlButton setTitle:@"SET A DEADLINE" forState:UIControlStateNormal];
		[_ddlButton addTarget:self action:@selector(setDeadline) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_ddlButton];
	}
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSCalendarUnit unit = NSCalendarUnitDay;
	
	
	[_dateLabel removeFromSuperview];
	
	_dateLabel = [[UILabel alloc] init];
	_dateLabel.frame = CGRectMake((w - lw) / 2.0, y, w, 158);
	[_dateLabel setFont:[UIFont fontWithName:@"din-light" size:20]];
	[_dateLabel setTextAlignment:NSTextAlignmentCenter];
	[_dateLabel setTextColor:[UIColor lightGrayColor]];
	_dateLabel.numberOfLines = 0;
	
	if (!_isNew && !_isComplete) {
		
		NSDate *now = [NSDate date];
		if ([now laterDate:_entry.dateToFulfill] == now) {
			NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:25],
									NSForegroundColorAttributeName: [UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]
									};
			NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Mission Failed" attributes:dict];

			[_dateLabel setAttributedText:str];
			[_descField setEditable:NO];
			[self.view addSubview:_dateLabel];
		}
		else {
			
			NSDateComponents *comp = [cal components:unit fromDate:[NSDate date] toDate:_entry.dateToFulfill options:0];
			
			NSString *text = [NSString stringWithFormat:@"You have\r\r%d\r\rdays to do it", (int)[comp day]];
			NSString *num = [NSString stringWithFormat:@"%d", (int)[comp day	]];
			
			NSDictionary *dict1 = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:18],
									NSForegroundColorAttributeName: [UIColor lightGrayColor]
									};
			
			NSDictionary *dict2 = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:88],
									NSForegroundColorAttributeName: [UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]
									};
			
			NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:dict1];
			
			const NSRange range = [text rangeOfString:num];
			[attrString addAttributes:dict2 range:range];
			[_dateLabel setAttributedText:attrString];
			
			[self.view addSubview:_dateLabel];
		}
	}
	if (_isComplete) {
		NSDateComponents *comp = [cal components:unit fromDate:_entry.dateCompleted toDate:[NSDate date] options:0];
		
		NSString *text = [NSString stringWithFormat:@"You did it\r\r%d\rdays ago", (int)[comp day]];
		NSString *num = [NSString stringWithFormat:@"%d", (int)[comp day	]];

		NSDictionary *dict1 = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:18],
								NSForegroundColorAttributeName: [UIColor lightGrayColor]
								};
		
		NSDictionary *dict2 = @{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:88],
								NSForegroundColorAttributeName: [UIColor colorWithRed:234.0/255.0 green:0.0/255.0 blue:42.0/255.0 alpha:1.0]
								};
		
		const NSRange range = [text rangeOfString:num];
		
		NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:dict1];
		[attrString addAttributes:dict2 range:range];
		[_dateLabel setAttributedText:attrString];
		
		[self.view addSubview:_dateLabel];
    }
}

- (void)setDeadline
{
    [[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"din-light" size:24]];
    [[SSFlatDatePicker appearance] setGradientColor:[UIColor whiteColor]];
    [[SSFlatDatePicker appearance] setTextColor:[UIColor blackColor]];
    _dp = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, 0, w * 0.9, h * 0.2)];
    
    UIViewController *dateVC = [[UIViewController alloc] init];
    dateVC.view = _dp;
    
    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:dateVC];
    destNav.modalPresentationStyle = UIModalPresentationPopover;
    dateVC.preferredContentSize = CGSizeMake(w * 0.9, h * 0.2);
    _ppc = destNav.popoverPresentationController;
    _ppc.delegate = self;
    _ppc.sourceView = self.view;
    _ppc.sourceRect = [_ddlButton frame];
    [_ppc setPermittedArrowDirections:UIPopoverArrowDirectionDown];
    [_ppc setBackgroundColor:[UIColor darkGrayColor]];
    
    destNav.navigationBarHidden = YES;
    [self presentViewController:destNav animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(nonnull UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void)popoverPresentationControllerDidDismissPopover:(nonnull UIPopoverPresentationController *)popoverPresentationController
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [formatter stringFromDate:[_dp date]];
    
    [self.navigationItem setTitle:dateString];
	
	
	NSDate *tmr = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[_dp date]];
	tmr = [[NSCalendar currentCalendar] startOfDayForDate:tmr];
    _dtc = [tmr dateByAddingTimeInterval:-1];
	
	_entry.dateToFulfill = _dtc;
	[self setDaysLabel];
}


- (void)save
{
	NSString *trimmedStr = [[_descField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedStr length] == 0) {
        /*UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:@"Set a goal" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [toast show];
        int duration = 0.9;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        }); */
		
		[RKDropdownAlert title:@"Set a target" message:nil backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
	if (_dp == nil) {
		[RKDropdownAlert title:@"Set a deadline" message:nil backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
	
	NSDate *now = [NSDate date];
	if ([now laterDate: _dtc] == now) {
		[RKDropdownAlert title:@"Set a valid deadline" message:nil backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
		return;
	}
	
    self.entry = [[ListEntries sharedEntries] createEntry];
    self.entry.desc = [_descField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.entry.dateToFulfill = _dtc;
    self.entry.dateCreated = [NSDate date];
    
    // local notification
	NSString *alertBodyStr = @"You have a task to complete";
	
	now = [NSDate date];
	NSDate *timeToFire = [NSDate dateWithTimeInterval:(24 * 60 * 60) sinceDate:now];
	
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	localNotification.fireDate = timeToFire;
	localNotification.repeatCalendar = [NSCalendar currentCalendar];
	localNotification.repeatInterval = NSCalendarUnitDay;
	localNotification.alertBody = alertBodyStr;
    localNotification.alertAction = @"open Passerby";
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]  + 1;

	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}


- (void)cancelEditting
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)editTask {

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Complete Task" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		
		self.entry.dateCompleted = [NSDate date];
		[[ListEntries sharedEntries] moveToCompleted:self.entry];
		
		UIButton *delBtn = [[UIButton alloc] init];
		UIImage *delImg = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[delBtn setImage:delImg forState:UIControlStateNormal];
		[delBtn setFrame:CGRectMake(0, 0, 25, 25)];
		delBtn.tintColor = [UIColor lightGrayColor];
		[delBtn addTarget:self action:@selector(deleteTask) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delBtn];
		self.navigationItem.rightBarButtonItem = rightBarButtonItem;
		
		[self.navigationItem setTitle: [NSString stringWithFormat:@"Completed on %@", [formatter stringFromDate:_entry.dateCompleted]]];
		
		_isNew = NO;
		_isComplete = YES;
		
		[self setDaysLabel];
	}];
	
	UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit Deadline" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
		[[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"din-light" size:24]];
		[[SSFlatDatePicker appearance] setGradientColor:[UIColor whiteColor]];
		[[SSFlatDatePicker appearance] setTextColor:[UIColor blackColor]];
		_dp = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, 0, w * 0.9, h * 0.2)];
		
		UIViewController *dateVC = [[UIViewController alloc] init];
		dateVC.view = _dp;
		
		UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:dateVC];
		destNav.modalPresentationStyle = UIModalPresentationPopover;
		dateVC.preferredContentSize = CGSizeMake(w * 0.9, h * 0.2);
		_ppc = destNav.popoverPresentationController;
		_ppc.delegate = self;
		_ppc.sourceView = self.view;
		_ppc.sourceRect = [_dateLabel frame];
		[_ppc setPermittedArrowDirections:UIPopoverArrowDirectionDown];
		[_ppc setBackgroundColor:[UIColor darkGrayColor]];
		
		destNav.navigationBarHidden = YES;
		[self presentViewController:destNav animated:YES completion:nil];
	}];
	
	UIAlertAction *del = [UIAlertAction actionWithTitle:@"Delete Task" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
		[[ListEntries sharedEntries] removeEntry:_entry];
		[self.navigationController popViewControllerAnimated:YES];
	}];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	
	[alert addAction:complete];
	[alert addAction:edit];
	[alert addAction:del];
	[alert addAction:cancel];
	
	[self presentViewController:alert animated:true completion:nil];
}

- (void)deleteTask
{
	
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:
                             ^(UIAlertAction *action){
                                 
								 [[ListEntries sharedEntries] removeEntry:self.entry];
								 [self.navigationController popViewControllerAnimated:true];
                                 
                             }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:OK];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow
{
    if (self.view.frame.origin.y >= 0) {
        [self moveUp:YES];
    }
    else [self moveUp:NO];
}

- (void)keyboardWillHide
{
    if (self.view.frame.origin.y < 0) {
        [self moveUp:NO];
    }
}

- (void)moveUp:(BOOL)move
{
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    
    CGFloat offset = h * 0.15 - 15;
    
    if (move) {
        rect.origin.y -= offset;
        rect.size.height += offset;
    }
    else {
        rect.origin.y += offset;
        rect.size.height -= offset;
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)goBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard
{
	[_descField endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    _titleField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(nonnull UITextField *)textField
{
    _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tap to set a new goal"
                                                                        attributes:@{
                                                                                     NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                     NSFontAttributeName: [UIFont fontWithName:@"din-light" size:22]
                                                                                     }];
}
*/

- (void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    [self moveUp:YES];
}

- (void)textViewDidEndEditing:(nonnull UITextView *)textView
{
    [self moveUp:NO];
}


- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
	[coder encodeObject:self.entry.entryKey forKey:@"entry.entryKey"];
	//self.entry.title = _titleField.text;
	self.entry.desc = _descField.text;
	
	[[ListEntries sharedEntries] saveChanges];
	
	[super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
	NSString *entryKey = [coder decodeObjectForKey:@"entry.entryKey"];
	for (ListEntry *entry in [[ListEntries sharedEntries] allEntries]) {
		if ([entryKey isEqualToString:entry.entryKey]) {
			self.entry = entry;
			break;
		}
	}
	[super decodeRestorableStateWithCoder:coder];
}

/*
- (BOOL)textView:(nonnull UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
 
- (BOOL)gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch
{
    if (touch.view == _saveButton) {
        return NO;
    }
    
    return YES;
}
 */

@end
