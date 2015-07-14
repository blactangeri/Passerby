#import <UIKit/UIKit.h>

@class ListEntry;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) ListEntry *entry;
- (instancetype)initForNewEntry:(BOOL)isNew;

extern CGFloat w;
extern CGFloat h;
@end
