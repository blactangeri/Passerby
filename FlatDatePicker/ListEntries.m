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
        _privateEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_privateEntries) {
            _privateEntries = [[NSMutableArray alloc] init];
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

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateEntries toFile:path];
}

- (NSArray *)allEntries
{
    return [self.privateEntries copy];
}

- (ListEntry *)createEntry
{
    ListEntry *entry = [[ListEntry alloc] init];
    [self.privateEntries addObject:entry];
    return entry;
}

- (void)removeEntry:(ListEntry *)entry
{
    [self.privateEntries removeObjectIdenticalTo:entry];
}

@end
