//
//  APIString.h
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIString : NSObject

extern NSString *API_Username;
extern NSString *API_Password;
extern NSString *API_BaseURL;

+(NSString*) getAPIUrl:(NSString*)functionName;

@end
