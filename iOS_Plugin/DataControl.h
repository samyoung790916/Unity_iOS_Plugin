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

// 회원가입
-(void)join:(char *)email
   password:(char *)pw
       name:(char *)name
 completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

// 로그인
-(void)login:(char *)email
    password:(char *)pw
  completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

// 기기 연결
-(void)device_connect:(char *)serialNumber
                Email:(char *)szEmail
           completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

// 기기리스트 호출
-(void)device_list:(char *)email
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

// 기기 연결 해제
-(void)device_quit:(char *)serialNumber
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

// 메시지 전송(기기생성, 기기토큰 생성, 채팅방 생성)
-(void)sendmessage:(char *)strMessage
        completion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completeHandler;

// sns 회원가입
-(void)snsJoin:(char *)sortDevice
         email:(char *)email
      snsToken:(char *)sns_token
snsTwiterToken:(char *)twiter_token
       snssort:(char *)sort
    completion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completeHandler;

//회원통합
-(void)member_integrated:(char *)sortDevice
                snsToken:(char *)snsToken
             twiterToken:(char *)snsTwiterToken
                 snsSort:(char *)snsSort
                   email:(char *)email
                      pw:(char *)pwd
               completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

//sns로그인
-(void)sns_login:(char *)sortDevice
        snsToken:(char *)snsToken
     twiterToken:(char *)snsTwiterToken
         snsSort:(char *)snsSort
           email:(char *)snsEmail
           snsId:(char *)snsId
      completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

//회원탈퇴
-(void)retirement:(char * )email
               pw:(char *)pw
          snsSort:(char *)sort
       completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

//패스워드 이메일 전송
-(void)passwordEmailTrans:(char *)email
                  snsSort:(char *)sort
               completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler; 

//패스워드 초기화
-(void)password_reset:(char *)pw
              snsSort:(char *)sort
           completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;


//앱 모델 별 리스트
-(void)app_list:(char *)country
     completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;

//앱 모델 상세
-(void)app_detail:(char *)productid
          country:(char *)country
       completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;
@end

NS_ASSUME_NONNULL_END
