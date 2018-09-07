//
//  History+CoreDataProperties.m
//  CFB
//
//  Created by 周鑫 on 2018/8/28.
//  Copyright © 2018年 ZX. All rights reserved.
//
//

#import "History+CoreDataProperties.h"

@implementation History (CoreDataProperties)

+ (NSFetchRequest<History *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"History"];
}

@dynamic min;
@dynamic max;
@dynamic time;
@dynamic location;

@end
