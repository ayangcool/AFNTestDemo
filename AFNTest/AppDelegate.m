//
//  AppDelegate.m
//  AFNTest
//
//  Created by Leo on 16/4/21.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^requestSuccessBlock)(id result);

typedef void (^requestFailureBlock)(NSInteger statusCode, NSError *error);

@interface LYAFNTools : NSObject

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success
    failure:(requestFailureBlock)failure;

+ (void)get:(NSString *)url success:(requestSuccessBlock)success
    failure:(requestFailureBlock)failure;

+ (void)requestGET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(requestSuccessBlock)success
    failure:(requestFailureBlock)failure;

@end

@implementation LYAFNTools

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure {
    [self requestGET:url parameters:parameters success:success failure:failure];
}

+ (void)get:(NSString *)url success:(requestSuccessBlock)success failure:(requestFailureBlock)failure {
    [self requestGET:url parameters:nil success:success failure:failure];
}

- (void)successHandle:(requestSuccessBlock)success failure:(requestFailureBlock)failure responseObject:(id )responseObject {
    if ([responseObject[@"status"] integerValue] == 200) {
        success(responseObject[@"result"]);
    } else {
        failure([responseObject[@"status"] integerValue], nil);
    }
}

+ (void)requestGET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[LYAFNTools new] successHandle:success failure:failure responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(100, error);
    }];
}

@end

@interface LYAFNTools (network)

+ (void)requestTokenIdcomplete:(void (^)(NSString *tokenId))complete failure:(void(^)(void))failure;

@end

@implementation LYAFNTools (network)

+ (void)requestTokenIdcomplete:(void (^)(NSString *))complete failure:(void (^)(void))failure {
    NSString *urlStr = @"http://192.168.8.3:3006/auth/getTokenId?terminal=ios&appID=d6c0e7997b8e46f8903d7e8460d15f2d&UUID=5AD5EAE2-A373-4C60-BB3E-73DEE3B0742D";
    [self requestGET:urlStr parameters:nil success:^(id result) {
        NSLog(@"%@", result);
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%@", error);
    }];
}


@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *vc = [UIViewController new];
    self.window.rootViewController = vc;
    
    [LYAFNTools requestTokenIdcomplete:^(NSString *tokenId) {
        NSLog(@"%@", tokenId);
    } failure:^{
        NSLog(@"");
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
