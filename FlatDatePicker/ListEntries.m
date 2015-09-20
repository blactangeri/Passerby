//
//  ListEntries.m
//  Passerby
//
//  Created by KING J on 7/11/15.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import "ListEntries.h"
#import "ListEntry.h"

@interface ListEntries()

@property (nonatomic) NSMutableArray *privateEntries;
@property (nonatomic) NSMutableArray *completedEntries;

@end

@implementation ListEntries

+ (instancetype)sharedEntries
{
    static ListEntries *sharedEntries;
    if (!sharedEntries) {
        sharedEntries = [[self alloc] initPrivate];
    }
    
    return sharedEntries;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        NSString *path2 = [self itemArchivePath2];
        _privateEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _completedEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
        if (!_privateEntries) {
            _privateEntries = [[NSMutableArray alloc] init];
        }
        if (!_completedEntries) {
            _completedEntries = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [ documentDirs firstObject];
    
    return [documentDir stringByAppendingPathComponent:@"entries.archive"];
}

- (NSString *)itemArchivePath2
{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [ documentDirs firstObject];
    
    return [documentDir stringByAppendingPathComponent:@"completedEntries.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    NSString *path2 = [self itemArchivePath2];
    
    return [NSKeyedArchiver archiveRootObject:self.privateEntries toFile:path] &&
            [NSKeyedArchiver archiveRootObject:self.completedEntries toFile:path2];
}

- (NSArray *)allEntries
{
    return [self.privateEntries copy];
}

- (NSArray *)allEntries2
{
    return [self.completedEntries copy];
}

- (ListEntry *)createEntry
{
    ListEntry *entry = [[ListEntry alloc] init];
    [self.privateEntries addObject:entry];
    return entry;
}

- (void)moveToCompleted:(ListEntry *)entry
{
    [self.completedEntries addObject:entry];
    [self.privateEntries removeObject:entry];
}

- (void)removeEntry:(ListEntry *)entry
{
    [self.privateEntries removeObjectIdenticalTo:entry];
	[_completedEntries removeObjectIdenticalTo:entry];
}

- (void)removeAll
{
    [self.completedEntries removeAllObjects];
}

@end
