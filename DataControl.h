//
//  DataControl.h
//  quickObjc_sample
//
//  Created by samyoung79 on 13/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebServices : NSObject

+(instancetype)sharedManager;
-(instancetype)init;
-(void)request:(NSString *)operation argment:(NSDictionary *)params complete:(void (^)(NSArray * list, NSError * error))completeHandler;
-(NSArray *)methodUsingJsonFromSuccessBlock:(NSData *)data;
@end


@interface DataControl : NSObject

@property (nonatomic) NSUInteger user_id;
@property (strong, nonatomic) QBChatDialog * dialog;



+(instancetype)sharedManager;

-(id)init;

-(void)join:(char *)email password:(char *)pw name:(char *)name completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;   // 회원가입
-(void)login:(char *)email password:(char *)pw completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;                    // 로그인
-(void)device_connect:(char *)serialNumber completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;                        // 기기 연결
-(void)device_list:(char *)email completion:(void (^)(BOOL success, NSString * resultMessage, NSArray * list))completeHandler;                  // 기기리스트 호출
-(void)device_quit:(char *)serialNumber completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;                           // 기기 연결 해제
-(void)sendmessage:(char *)strMessage completion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completeHandler;                    // 메시지 전송


@end

NS_ASSUME_NONNULL_END
