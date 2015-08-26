//
//  DayRate.h
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayRate : NSObject

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSMutableArray *rates;

+ (void)getDayRateWithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(DayRate *dayRateObject, BOOL success, NSError *error)) completionHandler;

+ (void)getDayRate90WithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(NSMutableArray *dayRateObjects, BOOL success, NSError *error)) completionHandler;

@end
