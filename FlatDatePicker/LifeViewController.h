
#import <UIKit/UIKit.h>

@interface LifeViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbi;

- (void)setMonth:(int)v;

@end
