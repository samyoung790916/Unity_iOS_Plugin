//
//  NativeiOSPlugin.m
//  quickObjc_sample
//
//  Created by samyoung79 on 19/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import "NativeiOSPlugin.h"
#import "DataControl.h"


@implementation NativeiOSPlugin

@end

extern "C"
{
    void JoinReqeust(char * szEmail,
                     char * szPw,
                     char * szName,
                     NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]join:szEmail password:szPw name:szName completion:^(BOOL success, NSString *  resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void LoginReqeust(char * szEmail,
                      char * szpw,
                      NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]login:szEmail password:szpw completion:^(BOOL success, NSString * result) {
            handler(success, strdup([result UTF8String]));
        }];
    }
    
    void SendMessageRequest(char * szMessage,
                            NativeDelegateNotification handler)
    {
        [[DataControl sharedManager] sendmessage:szMessage completion:^(BOOL success, NSString * _Nullable errorMessage) {
            handler(success, strdup([errorMessage UTF8String]));
        }];
    }

    
    void DeviceConnectRequest(char * szDevice,
                              char * szEmail,
                              NativeDelegateNotification handler)
    {

        [[DataControl sharedManager]device_connect:szDevice Email:szEmail completion:^(BOOL success, NSString * resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceQuitRequest(char * szDevice,
                           NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]device_quit:szDevice completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceListRequest(char * szEmail,
                           NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]device_list:szEmail completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    

    
    
    void snsJoinReqeust(char * szSortDevice,
                        char * szEmail,
                        char * snsToken,
                        char * szTwiterToken,
                        char * snsSort,
                        NativeDelegateNotification handler )
    {
        [[DataControl sharedManager]snsJoin:szSortDevice
                                      email:szEmail
                                   snsToken:snsToken
                             snsTwiterToken:szTwiterToken
                                    snssort:snsSort
                                 completion:^(BOOL success, NSString * resultMessage) {
                                     
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    
    void memberIntegrateRequest(char * szSortDevice,
                                char * szsnsToken,
                                char * szsnsTwiterToken,
                                char * szsnsSort,
                                char * szsnsEmail,
                                char * szpwd,
                                NativeDelegateNotification handler )
    {
        [[DataControl sharedManager]member_integrated:szSortDevice
                                             snsToken:szsnsToken
                                          twiterToken:szsnsTwiterToken
                                              snsSort:szsnsSort
                                                email:szsnsEmail
                                                   pw:szpwd
                                           completion:^(BOOL success, NSString * resultMessage) {
                                                handler(success, strdup([resultMessage UTF8String]));
                                             }];
    }
    
    void snsLoginReqeust(char * szSortDevice,
                         char * szsnsToken,
                         char * szsnsTwiterToken,
                         char * szsnsSort,
                         char * szsnsEmail,
                         char * szsnsId,
                         NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]sns_login:szSortDevice
                                     snsToken:szsnsToken
                                  twiterToken:szsnsTwiterToken
                                      snsSort:szsnsSort
                                        email:szsnsEmail
                                        snsId:szsnsId
                                   completion:^(BOOL success, NSString * resultMessage) {
                                       handler(success, strdup([resultMessage UTF8String]));
            
        }];
    }
    
    void retirementRequest(char * szEmail,
                           char * szPw,
                           char * sort,
                           NativeDelegateNotification handler)
    {
        // 회원탈퇴
        [[DataControl sharedManager]retirement:szEmail pw:szPw snsSort:sort
                                    completion:^(BOOL success, NSString * resultMessage) {
                                        handler(success, strdup([resultMessage UTF8String]));
                                    }];
    }
    
    void passwordEmailTransRequest(char * szEmail,
                                   char * szSort,
                                   NativeDelegateNotification handler)
    {   // 패스워드 이메일 전송
        [[DataControl sharedManager]passwordEmailTrans:szEmail snsSort:szSort completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    
    void passwordResetRequest(char * szPwd,
                              char * szSort,
                              NativeDelegateNotification handler)
    {
        // 패스워드 리셋
        [[DataControl sharedManager]password_reset:szPwd snsSort:szSort completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }

    void appListSearchRequest(char * szCountry,
                              NativeDelegateNotification handler)
    {   // 앱모델별 리스트 조회
        
        [[DataControl sharedManager]app_list:szCountry completion:^(BOOL success, NSString * _Nonnull resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void appDetailReqeust(char * szProductId,
                          char * szContry,
                          NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]app_detail:szProductId country:szContry completion:^(BOOL success, NSString * _Nonnull resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
}
