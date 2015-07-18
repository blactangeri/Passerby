
#import <UIKit/UIKit.h>

@interface LifeViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbi;
@property (nonatomic, weak) NSDate *dob;

- (void)setMonth:(int)v;

@end
