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
    void JoinReqeust(char * szEmail, char * szPw, char * szName, NativeDelegateNotification handler){
        [[DataControl sharedManager]join:szEmail password:szPw name:szName completion:^(BOOL success, NSString *  resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void LoginReqeust(char * szEmail, char * szpw, NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]login:szEmail password:szpw completion:^(BOOL success, NSString * result) {
            handler(success, strdup([result UTF8String]));
        }];
    }
    
    void DeviceConnectRequest(char * szDevice,char * szEmail,NativeDelegateNotification handler){
        [[DataControl sharedManager]device_connect:szDevice Email:szEmail completion:^(BOOL success, NSString * resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceQuitRequest(char * szDevice, NativeDelegateNotification handler){
        [[DataControl sharedManager]device_quit:szDevice completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceListRequest(char * szEmail, NativeDelegateNotification handler){
        [[DataControl sharedManager]device_list:szEmail completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
            
        }];
    }
    
    void SendMessageRequest(char * szMessage,NativeDelegateNotification handler){
        [[DataControl sharedManager] sendmessage:szMessage completion:^(BOOL success, NSString * _Nullable errorMessage) {
            handler(success, strdup([errorMessage UTF8String]));
        }];
    }
}
