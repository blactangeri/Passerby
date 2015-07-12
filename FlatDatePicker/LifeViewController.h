//
//  LifeViewController.h
//  Passerby
//
//  Created by KING J on 7/6/15.
//  Copyright © 2015 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbi;

- (void)setMonth:(int)v;

@end
