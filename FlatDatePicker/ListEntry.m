
#import "ListEntry.h"
@interface ListEntry()

@end

@implementation ListEntry

- (id)initWithTitle:(NSString *)title description:(NSString *)desc dateToFulfill:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.title = title;
        self.desc = desc;
        self.dateToFulfill = date;
        self.dateCreated = [[NSDate alloc] init];
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _entryKey = key;
    }
    
    return self;
}

- (id)init
{
    return [self initWithTitle:@"test" description:@"test" dateToFulfill:[NSDate date]];
}

- (id)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _desc = [aDecoder decodeObjectForKey:@"desc"];
        _dateToFulfill = [aDecoder decodeObjectForKey:@"dtf"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dc"];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.dateToFulfill forKey:@"dtf"];
    [aCoder encodeObject:self.dateCreated forKey:@"dc"];
}

@end
