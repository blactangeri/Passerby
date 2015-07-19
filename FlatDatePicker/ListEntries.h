//
//  ListEntries.h
//  Passerby
//
//  Created by KING J on 7/11/15.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ListEntry;

@interface ListEntries : NSObject

@property (nonatomic, readonly) NSArray *allEntries;
@property (nonatomic, readonly) NSArray *allEntries2;
+ (instancetype)sharedEntries;
- (ListEntry *)createEntry;
- (void)removeEntry:(ListEntry *)entry;
- (BOOL)saveChanges;
- (void)moveToCompleted:(ListEntry *)entry;
- (void)removeAll;
@end
