
#import "DetailViewController.h"
#import "ListEntries.h"
#import "ListEntry.h"
#import "UITextView+Placeholder.h"
#import "SSFlatDatePicker.h"


#define offsetForKeyboard 80.0

@interface DetailViewController () <UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate,
                                    UIPopoverPresentationControllerDelegate, UIViewControllerRestoration, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextView *descField;
@property (nonatomic, weak) IBOutlet UIButton *dateLabel;
@property (nonatomic, strong) UIPopoverPresentationController *ppc;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) SSFlatDatePicker *dp;

@end

CGFloat w;
CGFloat h;

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     w = [[UIScreen mainScreen] bounds].size.width;
     h = [[UIScreen mainScreen] bounds].size.height;
    
    [self setupBackground];
    [self setupTextField];
    [self setupTextView];
    [self setupDeadlineButton];
    [self setupSaveButton];
}


- (void)encodeRestorableStateWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeObject:self.entry.entryKey forKey:@"entry.entryKey"];
    self.entry.title = _titleField.text;
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:_descField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:[UITextView class]];
    
    if (!_isNew) {
        self.titleField.text = _entry.title;
        self.descField.text = _entry.desc;
        static NSDateFormatter *df;
        if (!df) {
            df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
        }
        self.dateLabel.titleLabel.text = [df stringFromDate:_entry.dateToFulfill];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:[UITextView class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:[UITextView class]];
    
    if (!_isNew) {
        _entry.title = self.titleField.text;
        _entry.desc = self.descField.text;
        _entry.dateToFulfill = [_dp date];
    }
}

- (void)setupBackground
{
    self.view.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:18],
                                                                      NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    UIButton *userButton = [[UIButton alloc] init];
    
    if (_isNew) {
        UIImage *userImg = [[UIImage imageNamed:@"cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userButton setImage:userImg forState:UIControlStateNormal];
        [userButton setFrame:CGRectMake(0, 0, 18, 18)];
        userButton.tintColor = [UIColor lightGrayColor];
        [userButton addTarget:self action:@selector(cancelEditting) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:userButton];
        self.navigationItem.leftBarButtonItem = left;
    }
    else {
        UIImage *userImg = [[UIImage imageNamed:@"cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [userButton setImage:userImg forState:UIControlStateNormal];
        [userButton setFrame:CGRectMake(0, 0, 18, 18)];
        userButton.tintColor = [UIColor lightGrayColor];
        [userButton addTarget:self action:@selector(cancelEditting) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:userButton];
        self.navigationItem.leftBarButtonItem = left;
    }

    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //[self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [_titleField endEditing:YES];
    [_descField endEditing:YES];
}

- (void)setupTextField
{
    _titleField.frame = CGRectMake(0, h * 0.3, w, 44);
    
    _titleField.delegate = self;
    _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tap to set a new goal"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                     NSFontAttributeName: [UIFont fontWithName:@"din-light" size:22]
                                                                                     }];
    [_titleField setFont:[UIFont fontWithName:@"din-light" size:22]];
    [_titleField setTextColor:[UIColor lightGrayColor]];
    [_titleField setTextAlignment:NSTextAlignmentCenter];
}

- (void)setupTextView
{
    _descField.frame = CGRectMake(w * 0.2 / 2.0, (h * 0.3 + 44) * 1.1, w * 0.8, h * 0.2);
    _descField.delegate = self;
    [_descField setFont:[UIFont fontWithName:@"din-light" size:18]];
    [_descField setTextColor:[UIColor lightGrayColor]];
    [_descField setTextAlignment:NSTextAlignmentJustified];
    _descField.text = @"";
    
    _descField.placeholder = @"Add description here. Life is short. Make each day count. Do something that makes your life a story worth telling.";
    _descField.placeholderColor = [UIColor grayColor];
}

- (void)setupDeadlineButton
{
    CGFloat lw = w / 2.0;
    CGFloat y = (_descField.frame.origin.y + _descField.frame.size.height) + 44;
    _dateLabel.frame = CGRectMake((w - lw) / 2.0, y, lw, 44);
    [_dateLabel setTitle:@"Set a deadline" forState:UIControlStateNormal];
    _dateLabel.titleLabel.font = [UIFont fontWithName:@"din-light" size:22];
    [_dateLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _dateLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.layer.borderWidth = 0;
}

- (IBAction)setDeadline:(id)sender
{
    [[SSFlatDatePicker appearance] setFont:[UIFont fontWithName:@"din-light" size:24]];
    [[SSFlatDatePicker appearance] setGradientColor:[UIColor darkGrayColor]];
    _dp = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, 0, w * 0.9, h * 0.2)];
    [_dp addTarget:self action:@selector(getDeadline) forControlEvents:UIControlEventValueChanged];
    
    UIViewController *dateVC = [[UIViewController alloc] init];
    dateVC.view = _dp;
    
    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:dateVC];
    destNav.modalPresentationStyle = UIModalPresentationPopover;
    dateVC.preferredContentSize = CGSizeMake(w * 0.9, h * 0.2);
    _ppc = destNav.popoverPresentationController;
    _ppc.delegate = self;
    _ppc.sourceView = self.view;
    _ppc.sourceRect = [sender frame];
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
    
    self.dateLabel.titleLabel.text = dateString;
}

- (void)setupSaveButton
{
    CGFloat bw = 200;
    CGFloat bh = 45;
    CGFloat x = (w - bw) / 2.0;
    CGFloat y = (_dateLabel.frame.origin.y + _dateLabel.frame.size.height) + 44;
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, bw, bh)];
    [self.view addSubview:_saveButton];
    [_saveButton setBackgroundColor:[UIColor darkGrayColor]];
    _saveButton.layer.cornerRadius = 23;
    [_saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [_saveButton.titleLabel setFont:[UIFont fontWithName:@"din-light" size:20]];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(changeBgColor) forControlEvents:UIControlEventTouchDown];
    [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

- (void)save
{
    [_saveButton setBackgroundColor:[UIColor darkGrayColor]];
    
    if (!_titleField.text || _titleField.text.length == 0) {
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:@"Empty title" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [toast show];
        int duration = 0.7;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        return;
    }
    else if (_dp == nil) {
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:@"Set a deadline" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [toast show];
        int duration = 0.7;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        return;
    }
    
    self.entry = [[ListEntries sharedEntries] createEntry];
    self.entry.title = _titleField.text;
    self.entry.desc = _descField.text;
    self.entry.dateToFulfill = [_dp date];
    self.entry.dateCreated = [NSDate date];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeBgColor
{
    [_saveButton setBackgroundColor:[UIColor grayColor]];
}

- (void)cancelEditting
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    if (move) {
        rect.origin.y -= offsetForKeyboard;
        rect.size.height += offsetForKeyboard;
    }
    else {
        rect.origin.y += offsetForKeyboard;
        rect.size.height -= offsetForKeyboard;
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



- (void)complete
{
    [[ListEntries sharedEntries] removeEntry:self.entry];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    [self moveUp:YES];
}

- (void)textViewDidEndEditing:(nonnull UITextView *)textView
{
    [self moveUp:NO];
}

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

@end
