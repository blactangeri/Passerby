//
//  ListEntry.h
//  Passerby
//
//  Created by KING J on 7/11/15.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListEntry : NSObject<NSCoding>

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)desc dateToFulfill:(NSDate *)date;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *dateToFulfill;
@property (nonatomic, copy) NSString *entryKey;
@property (nonatomic, strong) NSString *dateCompleted;

@end
