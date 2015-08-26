//
//  DayRate.m
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "DayRate.h"
#import "APIString.h"
#import <AFNetworking/AFNetworking.h>

@implementation DayRate

+ (void)getDayRateWithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(DayRate *dayRateObject, BOOL success, NSError *error)) completionHandler{
    
    NSString *urlString = [APIString getAPIUrl:@"dayrate"];
    
    AFHTTPRequestOperationManager *afRequest = [AFHTTPRequestOperationManager manager];
    
    afRequest.requestSerializer = [AFJSONRequestSerializer serializer];
    afRequest.responseSerializer.acceptableContentTypes = [afRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [afRequest.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    [afRequest GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response object = %@", responseObject);
        DayRate *dayRateObject = [DayRate new];
        NSString *str  = [responseObject objectForKey:@"Day"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        NSDate *day = [formatter dateFromString:str];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        dayRateObject.day = [formatter stringFromDate:day];
        dayRateObject.rates = [responseObject objectForKey:@"Rates"];
        completionHandler(dayRateObject, YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if(statusCode == 401) {
            completionHandler(nil, NO, nil);
        }else{
            completionHandler(nil, NO, error);
        }
    }];

}

+ (void)getDayRate90WithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(NSMutableArray *dayRateObjects, BOOL success, NSError *error)) completionHandler{
    NSString *urlString = [APIString getAPIUrl:@"dayrate90"];
    
    AFHTTPRequestOperationManager *afRequest = [AFHTTPRequestOperationManager manager];
    
    afRequest.requestSerializer = [AFJSONRequestSerializer serializer];
    afRequest.responseSerializer.acceptableContentTypes = [afRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [afRequest.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    [afRequest GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response object = %@", responseObject);
        NSMutableArray *responseObjectArray = [responseObject mutableCopy];
        NSMutableArray *dayRateObjects = [NSMutableArray new];
        for (int i = 0; i < responseObjectArray.count; i++) {
            DayRate *dayRateObject = [DayRate new];
            NSString *str  = [responseObjectArray[i] objectForKey:@"Day"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            NSDate *day = [formatter dateFromString:str];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            dayRateObject.day = [formatter stringFromDate:day];
            dayRateObject.rates = [responseObjectArray[i] objectForKey:@"Rates"];
            [dayRateObjects addObject:dayRateObject];
        }
        completionHandler(dayRateObjects, YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if(statusCode == 401) {
            completionHandler(nil, NO, nil);
        }else{
            completionHandler(nil, NO, error);
        }
    }];
}

@end
