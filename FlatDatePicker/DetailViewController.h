#import <UIKit/UIKit.h>

@class ListEntry;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) ListEntry *entry;
@property (nonnull, copy) void (^dismissBlock)(void);
@property (nonatomic) BOOL isNew;
@property (nonatomic) BOOL isComplete;

extern CGFloat w;
extern CGFloat h;
@end
