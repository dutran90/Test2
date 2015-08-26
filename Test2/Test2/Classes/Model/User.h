//
//  UserObject.h
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

//+ (BOOL)checkLoginWithUsername: (NSString *)username andPassword: (NSString *)password;

@end
