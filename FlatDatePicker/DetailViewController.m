

#import "DetailViewController.h"
#import "DeformationButton/DeformationButton.h"
#import "ListEntries.h"
#import "ListEntry.h"



#define offsetForKeyboard 80.0

@interface DetailViewController () <UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextView *descField;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *leftBbi;
@property (nonatomic, strong) UIPopoverController *datepickerPopover;

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
    [self setupLabel];
    [self setupButton];
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
}

- (void)setupBackground
{
    self.view.backgroundColor = [UIColor colorWithRed:39.0 / 255.0 green:40.0 / 255.0 blue:34.0 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.title = @"CREATE A NEW GOAL";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"din-light" size:18],
                                                                      NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    UIButton *userButton = [[UIButton alloc] init];
    UIImage *userImg = [[UIImage imageNamed:@"cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:userImg forState:UIControlStateNormal];
    [userButton setFrame:CGRectMake(0, 0, 18, 18)];
    userButton.tintColor = [UIColor lightGrayColor];
    [userButton addTarget:self action:@selector(cancelEditting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    self.navigationItem.leftBarButtonItem = left;

    [_leftBbi setTarget:self];
    [_leftBbi setAction:@selector(cancelEditting)];
}

- (void)setupTextField
{
    _titleField.frame = CGRectMake(0, h * 0.3, w, 44);
    
    _titleField.delegate = self;
    _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tap to set a new goal"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],
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
    [_descField setText:@"Add description here. Life is short. Make each day count. Do something that makes your life a story worth telling."];
    [_descField setFont:[UIFont fontWithName:@"din-light" size:18]];
    [_descField setTextColor:[UIColor lightGrayColor]];
    [_descField setTextAlignment:NSTextAlignmentJustified];
}

- (void)setupLabel
{
    CGFloat lw = w / 2.0;
    CGFloat y = (_descField.frame.origin.y + _descField.frame.size.height) * 1;
    _dateLabel.frame = CGRectMake((w - lw) / 2.0, y, lw, 44);
    _dateLabel.text = @"Set a deadline";
    _dateLabel.font = [UIFont fontWithName:@"din-light" size:18];
    _dateLabel.textColor = [UIColor lightGrayColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupButton
{
    CGFloat bw = 100;
    CGFloat bh = 40;
    CGFloat x = (w - bw) / 2.0;
    CGFloat y = (_dateLabel.frame.origin.y + _dateLabel.frame.size.height) * 1.1;
    
    DeformationButton *deformationBtn = [[DeformationButton alloc] initWithFrame:CGRectMake(x, y, bw, bh) withColor:[UIColor grayColor]];
    [self.view addSubview:deformationBtn];
    
    [deformationBtn.forDisplayButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [deformationBtn.forDisplayButton.titleLabel setFont:[UIFont fontWithName:@"din-light" size:20]];
    [deformationBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deformationBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[deformationBtn addTarget:self action:@selector(gotoLife) forControlEvents:UIControlEventTouchUpInside];
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
                                                                                     NSForegroundColorAttributeName:[UIColor lightGrayColor],
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
    if ([textView.text isEqualToString:@"Add description here. Life is short. Make each day count. Do something that makes your life a story worth telling."]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
    
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

@end
