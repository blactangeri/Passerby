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

+ (instancetype)sharedEntries;
- (ListEntry *)createEntry;
- (void)removeEntry:(ListEntry *)entry;
- (BOOL)saveChanges;

@end
