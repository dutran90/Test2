//
//  APIString.m
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "APIString.h"

@implementation APIString

NSString const  *API_Username = @"foo";
NSString const  *API_Password = @"bar";
NSString const  *API_BaseURL = @"https://vast-scrubland-3894.herokuapp.com";

+(NSString*)getAPIUrl:(NSString *)functionName{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",API_BaseURL,functionName];
    return urlString;
}

@end
