//
//  History+CoreDataProperties.h
//  CFB
//
//  Created by 周鑫 on 2018/8/28.
//  Copyright © 2018年 ZX. All rights reserved.
//
//

#import "History+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface History (CoreDataProperties)

+ (NSFetchRequest<History *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *min;
@property (nullable, nonatomic, copy) NSString *max;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *location;

@end

NS_ASSUME_NONNULL_END
