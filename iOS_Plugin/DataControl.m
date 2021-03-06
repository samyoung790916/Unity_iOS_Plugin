//
//  DataControl.m
//  quickObjc_sample
//
//  Created by samyoung79 on 13/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import "DataControl.h"
#import <QMServicesManager.h>

@implementation WebServices

NSString * baseUrl = @"http://34.93.223.59:5006/";

QBUUser * g_user;

+(instancetype)sharedManager
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)request:(NSString *)operation
       argment:(NSDictionary *)params
      complete:(void (^)(NSArray * list, NSError * error))completeHandler
{

    NSString * method = [NSString stringWithFormat:@"%@%@",baseUrl,operation];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:method parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(completeHandler){
            completeHandler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completeHandler) {
            completeHandler(nil, error);
        }
    }];
}

-(void)get_request_detail:(NSString *)operation
                  argment:(NSDictionary *)params
                 complete:(void (^)(NSArray * list, NSError * error))completeHandler
{
    NSString * method = [NSString stringWithFormat:@"http://www.uoplusappstore.com:8080/Client/appInfo/{%@}?hl={%@}",[params valueForKey:@"PRODUCT_ID"],[params valueForKey:@"APP_COUNTRY"]];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:method parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completeHandler){
            completeHandler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completeHandler){
            completeHandler(nil,error);
        }
    }];
}


-(void)get_request_list:(NSString *)operation
               argument:(NSDictionary *)params
               complete:(void (^)(NSArray * list, NSError * error))completeHandler
{
    NSString * strContry = [params valueForKey:@"APP_COUNTRY"];
    
    if([strContry isEqualToString:@"KR"] == YES ||
       [strContry isEqualToString:@"US"] == YES ||
       [strContry isEqualToString:@"JP"] == YES ||
       [strContry isEqualToString:@"CN"] == YES)
    {
        NSString * method = [NSString stringWithFormat:@"http://www.uoplusappstore.com:8080/apps/UOplus/top-app/all?hl=%@",[params valueForKey:@"APP_COUNTRY"]];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:method parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(completeHandler){
                completeHandler(responseObject,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(completeHandler){
                completeHandler(nil,error);
            }
        }];
        
    }
    else{
        completeHandler(nil,nil);
    }
}

-(NSArray *)methodUsingJsonFromSuccessBlock:(NSData *)data
{
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    return jsonArray;
}
@end


typedef void(^CompleteHandler)(BOOL success, NSString * _Nullable errorMessage);
typedef void(^StatusHandler)(BOOL success);

@interface DataControl ()<QMChatServiceDelegate>
@property(strong,nonatomic)CompleteHandler completeHander;
@property(strong,nonatomic)StatusHandler statusHandler;
@end

@implementation DataControl

const NSUInteger kApplicationID = 7;
NSString * const kAuthKey        = @"SfK7Oagt8ksN7p-";
NSString * const kAuthSecret     = @"O5k266HKdmuAX8x";
NSString * const kAccountKey     = @"1sBGVjaxojoFec9JAZtD";

+(instancetype)sharedManager;
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.statusHandler = nil;
        self.user_id = 0;
        
        [QBSettings setApplicationID:kApplicationID];
        [QBSettings setAuthKey:kAuthKey];
        [QBSettings setAuthSecret:kAuthSecret];
        [QBSettings setAccountKey:kAccountKey];
        
        [QBSettings setApiEndpoint:@"https://api1thefull.quickblox.com"];
        [QBSettings setChatEndpoint:@"chat1thefull.quickblox.com"];

        [QBSettings setCarbonsEnabled:YES];
        [QBSettings enableXMPPLogging];
    
        [[QMServicesManager instance].chatService addDelegate:self];
        [QMServicesManager instance].chatService.chatAttachmentService.delegate = self;
    }
    return self;
}


#pragma mark - QMChatServiceDelegate

-(void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID{
    if ([self.dialog.ID isEqualToString:chatDialogID]) {
    }
}

- (void)chatService:(QMChatService *)chatService didLoadMessagesFromCache:(NSArray<QBChatMessage *> *)messages forDialogID:(NSString *)dialogID{

    if ([self.dialog.ID isEqualToString:dialogID]) {
    }
}

-(void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog{
    if ([self.dialog.ID isEqualToString:chatDialog]) {
    }
}

-(void)chatService:(QMChatService *)chatService didUpdateMessage:(QBChatMessage *)message forDialogID:(NSString *)dialogID{
}

- (void)chatService:(QMChatService *)chatService didUpdateMessages:(NSArray *)messages forDialogID:(NSString *)dialogID {
    if ([self.dialog.ID isEqualToString:dialogID]) {
    }
}
- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog{
    
    if(self.dialog.type != QBChatDialogTypePrivate && [self.dialog.ID isEqualToString:chatDialog.ID]){
        self.dialog = chatDialog;
        
        if(_completeHander){
            if (chatDialog.lastMessageUserID != self.user_id){
                _completeHander(YES,  chatDialog.lastMessageText);
            }else{
                
            }
        }
    }
}

-(NSString *)encodeStringTo64:(NSString*)fromString
{
    NSData * plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    }else{
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    return base64String;
}

-(void)join:(char *)email
   password:(char *)pw
       name:(char *)name
 completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * pwd = [self encodeStringTo64:@(pw)];
    NSDictionary * param = @{@"email":@(email),@"pwd":pwd,@"name":@(name)};
    
    [[WebServices sharedManager]request:@"join/uoplus" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        
        NSMutableDictionary * json = [NSMutableDictionary new];
        NSMutableDictionary * subjson = [NSMutableDictionary new];
        NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
        
        [json setValue:@"" forKey:@"senderId"];
        [json setValue:@"" forKey:@"receiverId"];
        [json setValue:number forKey:@"date"];
        [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
        [subjson setValue:nil forKey:@"bundle"];
        [subjson setValue:@"RESPONSE" forKey:@"type"];
        
        if(error != nil){
            [subjson setValue:@"Error_client_network_error/server" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
            return;
        }
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0){
            [subjson setValue:@"Error_client_join_fail" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
        }
        else{
            [subjson setValue:@"Success_client_join" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(YES,jsonstr);
        }
    }];
}


-(void)login:(char *)email
    password:(char *)pw
  completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    
    NSString * pwd = [self encodeStringTo64:@(pw)];
    NSDictionary * param = @{@"email":@(email),@"pwd":pwd};
    
    _completeHander = completeHandler;

    [[WebServices sharedManager]request:@"login/uoplus"
                                argment:param
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error)
    {
        NSMutableDictionary * json = [NSMutableDictionary new];
        NSMutableDictionary * subjson = [NSMutableDictionary new];
        NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
        
        [json setValue:@"" forKey:@"senderId"];
        [json setValue:@"" forKey:@"receiverId"];
        [json setValue:number forKey:@"date"];
        [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
        [subjson setValue:nil forKey:@"bundle"];
        [subjson setValue:@"RESPONSE" forKey:@"type"];

        if(error == nil)
        {
            int nStautsCode = [[list valueForKey:@"status_code"]intValue];
            
            if(nStautsCode != 0)
            {
                [subjson setValue:@"Error_client_server_error" forKey:@"action"];
                [json setValue:subjson forKey:@"command"];
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                completeHandler(NO,jsonstr);
                return;
            }
            
            NSDictionary * pDict = [list valueForKey:@"data"];
            self.user_id = [[list valueForKey:@"qb_id"]intValue];
            
            NSString * strpw = [list valueForKey:@"qb_pw"];
            NSString * strEmail = pDict[@"email"];

            g_user = [QBUUser user];
            g_user.ID = self.user_id;
            g_user.password = strpw;
            g_user.login = strEmail;
            
            [DataControl sharedManager];
            [[QMServicesManager instance]logInWithUser:g_user
                                            completion:^(BOOL success, NSString * _Nullable errorMessage)
            {
                if(success)
                {
                    [[QMServicesManager instance].chatService allDialogsWithPageLimit:10
                                                                   extendedRequest:nil
                                                                    iterationBlock:^(QBResponse * _Nonnull response,
                                                                                     NSArray<QBChatDialog *> * _Nullable dialogObjects,
                                                                                     NSSet<NSNumber *> * _Nullable dialogsUsersIDs,
                                                                                     BOOL * _Nonnull stop){
                                                                        
                                                                        
                        if(dialogObjects.count == 0){
                        }else{
                            self.dialog = dialogObjects[0];
                            __block DataControl * blockself = self;
                            
                            [self.dialog setOnJoinOccupant:^(NSUInteger userID) {
                                if(self.statusHandler != nil){
                                    blockself.statusHandler(YES); // 전원이 다시 들어왔을때
                                }
                            }];
                            
                            [self.dialog setOnLeaveOccupant:^(NSUInteger userID) {
                                if(self.statusHandler != nil){
                                    blockself.statusHandler(NO); // 전원이 다시 꺼졌을때
                                }
                            }];
                        }
                        [subjson setValue:@"Success_client_connected" forKey:@"action"];
                        [json setValue:subjson forKey:@"command"];
                                                                        
                        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                        NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                        completeHandler(YES,jsonstr);

                    }completion:^(QBResponse * _Nonnull response) {}];
                }
                else{
                    [subjson setValue:@"Error_client_login_fail" forKey:@"action"];
                    [json setValue:subjson forKey:@"command"];
                    
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                    NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    completeHandler(NO,jsonstr);
                }
            }];
        }
        else
        {
            [subjson setValue:@"Error_client_login_fail" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
        
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            _completeHander(NO,jsonstr);
        }
    }];
}

-(void)device_connect:(char *)serialNumber
                Email:(char *)szEmail
           completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:@(serialNumber),@"DEVICE_ID",@(szEmail),@"USER_ID",nil];
    
    [[WebServices sharedManager]request:@"uoplus/connect/device"
                                argment:param
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error)
    {
        NSMutableDictionary * json = [NSMutableDictionary new];
        NSMutableDictionary * subjson = [NSMutableDictionary new];
        NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
        
        [json setValue:@"" forKey:@"senderId"];
        [json setValue:@"" forKey:@"receiverId"];
        [json setValue:number forKey:@"date"];
        [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
        [subjson setValue:nil forKey:@"bundle"];
        [subjson setValue:@"RESPONSE" forKey:@"type"];
        
        
        if(error != nil){
            [subjson setValue:@"Error_client_network_error/server" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
            return;
        }
        
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode == -1)
        {
            [subjson setValue:@"Error_client_wolf_connnect_fail" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
            
        }
        else
        {
            [subjson setValue:@"Success_client_connected" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(YES,jsonstr);
            
            
            [[QMServicesManager instance]logInWithUser:g_user
                                            completion:^(BOOL success, NSString * _Nullable errorMessage) {
                
                if(success)
                {
                    [[QMServicesManager instance].chatService allDialogsWithPageLimit:10
                                                                      extendedRequest:nil
                                                                       iterationBlock:^(QBResponse * _Nonnull response,
                                                                                        NSArray<QBChatDialog *> * _Nullable dialogObjects,
                                                                                        NSSet<NSNumber *> * _Nullable dialogsUsersIDs,
                                                                                        BOOL * _Nonnull stop)
                    {
                        if(dialogObjects.count == 0){
                        }
                        else{
                            self.dialog = dialogObjects[0];
                        }
                    }completion:^(QBResponse * _Nonnull response) {}];
                }
            }];
            
            if(self.statusHandler != nil){
                self.statusHandler(YES);
            }
        }
    }];
}

-(void)device_quit:(char *)serialNumber
             email:(char *)szEmail
              sort:(char *)szSort
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    NSMutableDictionary * subjson = [NSMutableDictionary new];
    NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
    
    [json setValue:@"" forKey:@"senderId"];
    [json setValue:@"" forKey:@"receiverId"];
    [json setValue:number forKey:@"date"];
    [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
    [subjson setValue:nil forKey:@"bundle"];
    [subjson setValue:@"RESPONSE" forKey:@"type"];
    
    NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:
                            @(serialNumber),@"DEVICE_ID",
                            @(szEmail),@"USER_ID",
                            @(szSort),@"sort",
                            nil];
    
    NSString * strMethod = [NSString stringWithFormat:@"%@/quit/chat",[NSString stringWithUTF8String:szSort]];
    
    [[WebServices sharedManager]request:strMethod
                                argment:param
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error)
    {
        if(error != nil){
            [subjson setValue:@"Error_client_network_error/server" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
            return;
        }
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0)
        {
            [subjson setValue:@"Error_client_server_error" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
        }
        else
        {
            
            [subjson setValue:@"Success_client_unregister_device" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(YES,jsonstr);
        }
    }];
}

-(void)device_list:(char *)szEmail
              sort:(char *)szSort
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    NSMutableDictionary * subjson = [NSMutableDictionary new];
    NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
    
    [json setValue:@"" forKey:@"senderId"];
    [json setValue:@"" forKey:@"receiverId"];
    [json setValue:number forKey:@"date"];
    [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
    [subjson setValue:nil forKey:@"bundle"];
    [subjson setValue:@"RESPONSE" forKey:@"type"];
    
    NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:@(szEmail),@"USER_ID",
                                                                       @(szSort),@"sort",
                                                                        nil];
    
    NSString * strMethod = [NSString stringWithFormat:@"%@/search/device",[NSString stringWithUTF8String:szSort]];
    
    [[WebServices sharedManager]request:strMethod
                                argment:param
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error)
    {
        if(error != nil){
            [subjson setValue:@"Error_client_network_error/server" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
            return;
        }
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        NSDictionary * dict = [list copy];
        
        for(id key in [dict allKeys]){
            
            if([key isEqualToString:@"deviceList"]){
                [subjson setValue:[dict objectForKey:@"deviceList"]  forKey:@"bundle"];
                break;
            }
            else{
                [subjson setValue:nil forKey:@"bundle"];
            }
        }
        
        if(nStautsCode != 0)
        {
            [subjson setValue:@"Error_client_server_error" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
        }
        else{
            [subjson setValue:@"Success_client_devicelist" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            [subjson setValue:@"list" forKey:@"bundle"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(YES,jsonstr);
        }
    }];
}

-(void)sendmessage:(char *)szMessage
        completion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completeHandler
{
    QBChatMessage * message = [QBChatMessage new];
    message.text = @(szMessage);
    message.senderID = [QBSession currentSession].currentUser.ID;
    message.dialogID = self.dialog.ID;
    message.dateSent = [NSDate date];
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    NSMutableDictionary * subjson = [NSMutableDictionary new];
    NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
    
    [json setValue:@"" forKey:@"senderId"];
    [json setValue:@"" forKey:@"receiverId"];
    [json setValue:number forKey:@"date"];
    [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
    [subjson setValue:nil forKey:@"bundle"];
    [subjson setValue:@"RESPONSE" forKey:@"type"];
    
    
    [self.dialog requestOnlineUsersWithCompletionBlock:^(NSMutableArray<NSNumber *> * _Nullable onlineUsers, NSError * _Nullable error){
        BOOL bFind = NO;
        [subjson setValue:@"Error_client_wolf_message_invalid_protocol" forKey:@"action"];
        [json setValue:subjson forKey:@"command"];
        
        for(id element in onlineUsers)
        {
            NSString * strNumber = [element stringValue];
            NSString * strMasterUserID = [NSString stringWithFormat:@"%ld",self.dialog.userID];
            
            if([strNumber isEqualToString:strMasterUserID] == YES)
            {
                bFind = YES;
                [[QMServicesManager instance].chatService sendMessage:message
                                                           toDialogID:self.dialog.ID
                                                        saveToHistory:YES
                                                        saveToStorage:YES
                                                           completion:^(NSError * _Nullable error)
                 {
                     if(error != nil)
                     {
                         //[subjson setValue:@"Error_client_network_error" forKey:@"action"];
                         [subjson setValue:@"Success_client_request" forKey:@"action"];
                         [json setValue:subjson forKey:@"command"];
                         
                         NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                         NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                         completeHandler(YES,jsonstr);
                     }
                     else{
                         [subjson setValue:@"Success_client_request" forKey:@"action"];
                         [json setValue:subjson forKey:@"command"];
                         
                         NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                         NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                         completeHandler(YES,jsonstr);
                     }
                 }];
            }
        }
        if(bFind == NO)
        {
            [subjson setValue:@"Error_client_wolf_connect_fail" forKey:@"action"];
            [json setValue:subjson forKey:@"command"];
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            completeHandler(NO,jsonstr);
        }
    }];
}



-(void)snsJoin:(char *)sortDevice
         email:(char *)email
      snsToken:(char *)sns_token
snsTwiterToken:(char *)twiter_token
       snssort:(char *)sort
    completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * strMethod = @"/join_sns/";
    NSString * strDevice = [NSString stringWithUTF8String:sortDevice];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    else{
    }
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:sortDevice] forKey:@"sort"];
    [json setValue:[NSString stringWithUTF8String:email] forKey:@"email"];
    [json setValue:[NSString stringWithUTF8String:sns_token] forKey:@"sns_access_token"];
    
    if(twiter_token != NULL){
        [json setValue:[NSString stringWithUTF8String:twiter_token] forKey:@"sns_secret_token"];
    }
    
    [json setValue:[NSString stringWithUTF8String:sort] forKey:@"sns_sort"];
    
    [[WebServices sharedManager]request:strMethod
                                argment:json
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}

//회원통합
-(void)member_integrated:(char *)sortDevice
                snsToken:(char *)snsToken
             twiterToken:(char *)snsTwiterToken
                 snsSort:(char *)snsSort
                   email:(char *)email
                      pw:(char *)pwd
               ompletion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    
    NSString * strMethod = @"/join_intergration/";
    NSString * strDevice = [NSString stringWithUTF8String:sortDevice];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    else{
    }
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:sortDevice] forKey:@"sort"];
    [json setValue:[NSString stringWithUTF8String:snsToken] forKey:@"sns_access_token"];
    
    if(snsTwiterToken != NULL){
        [json setValue:[NSString stringWithUTF8String:snsTwiterToken] forKey:@"sns_secret_token"];
    }
    
    [json setValue:[NSString stringWithUTF8String:snsSort] forKey:@"sns_sort"];
    [json setValue:[NSString stringWithUTF8String:email] forKey:@"email"];
    [json setValue:[NSString stringWithUTF8String:pwd] forKey:@"pwd"];
    
    [[WebServices sharedManager]request:strMethod argment:json complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}

//sns로그인
-(void)sns_login:(char *)sortDevice
        snsToken:(char *)snsToken
     twiterToken:(char *)snsTwiterToken
         snsSort:(char *)snsSort
           email:(char *)snsEmail
           snsId:(char *)snsId
      completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    
    NSString * strMethod = @"/sns_login/";
    NSString * strDevice = [NSString stringWithUTF8String:sortDevice];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    else{
    }
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:sortDevice] forKey:@"sort"];
    [json setValue:[NSString stringWithUTF8String:snsSort] forKey:@"sns_access_token"];
    [json setValue:[NSString stringWithUTF8String:snsToken] forKey:@"sns_secret_token"];
    
    if(snsTwiterToken != NULL){
        [json setValue:[NSString stringWithUTF8String:snsTwiterToken] forKey:@"sns_secret_token"];
    }
    
    [json setValue:[NSString stringWithUTF8String:snsSort] forKey:@"sns_sort"];
    [json setValue:[NSString stringWithUTF8String:snsEmail] forKey:@"email"];
    [json setValue:[NSString stringWithUTF8String:snsId] forKey:@"sns_id"];
    
    
    [[WebServices sharedManager]request:strMethod
                                argment:json
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}

//회원탈퇴
-(void)retirement:(char * )email
               pw:(char *)pw
          snsSort:(char *)sort
       completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    
    NSString * strMethod = @"/deleteUser/";
    NSString * strDevice = [NSString stringWithUTF8String:sort];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    
    NSString * pwd = [self encodeStringTo64:@(pw)];
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:email] forKey:@"email"];
    [json setValue:pwd forKey:@"pwd"];
    [json setValue:[NSString stringWithUTF8String:sort] forKey:@"sort"];
   
    
    [[WebServices sharedManager]request:strMethod
                                argment:json
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
    
}

//패스워드 이메일 전송
-(void)passwordEmailTrans:(char *)email
                  snsSort:(char *)sort
               completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * strMethod = @"/requestResetPassword/";
    NSString * strDevice = [NSString stringWithUTF8String:sort];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:email] forKey:@"email"];
    [json setValue:[NSString stringWithUTF8String:sort] forKey:@"sort"];
    
    [[WebServices sharedManager]request:strMethod argment:json complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}

//패스워드 초기화
-(void)password_reset:(char *)pw
              snsSort:(char *)sort
           completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * strMethod = @"/resetPassword/";
    NSString * strDevice = [NSString stringWithUTF8String:sort];
    
    if([strDevice isEqualToString:@"uoplus"] == YES || [strDevice isEqualToString:@"octos"] == YES){
        strMethod = [NSString stringWithFormat:@"%@%@",strMethod,strDevice];
    }
    
    NSMutableDictionary * json = [NSMutableDictionary new];
    NSString * pwd = [self encodeStringTo64:@(pw)];
    [json setValue:pwd forKey:@"pwd"];
    [json setValue:[NSString stringWithUTF8String:sort] forKey:@"sort"];
    
    [[WebServices sharedManager]request:strMethod argment:json complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}


-(void)app_list:(char *)country
     completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:country] forKey:@"APP_COUNTRY"];
    
    [[WebServices sharedManager]get_request_list:nil argument:json complete:^(NSArray *list, NSError *error) {
        [self section:list error:error completion:completeHandler];
    }];
}

//앱상세
-(void)app_detail:(char *)productid
           country:(char *)country
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler;
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:productid] forKey:@"PRODUCT_ID"];
    [json setValue:[NSString stringWithUTF8String:country] forKey:@"APP_COUNTRY"];
    
    [[WebServices sharedManager]get_request_detail:nil argment:json complete:^(NSArray * list, NSError * error) {
        [self section:list error:error completion:completeHandler];
    }];
}

-(void)set_device_status:(void (^)(BOOL success))completeHandler{
    self.statusHandler = completeHandler;
}

//회원정보 수정
-(void)update_user:(char *)email
              name:(char *)szName
             birth:(char *)szBirth
           address:(char *)szAdrress
              sort:(char *)szSort
        completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:email] forKey:@"USER_ID"];
    [json setValue:[NSString stringWithUTF8String:szName] forKey:@"USER_BIRTH"];
    [json setValue:[NSString stringWithUTF8String:szAdrress] forKey:@"USER_ADDRESS"];
    
    NSString * strMethod = [NSString stringWithFormat:@"/updateUser/%@",[NSString stringWithUTF8String:szSort]];
    
    
    [[WebServices sharedManager]request:strMethod
                                argment:json
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}


//아이디 찾기
-(void)find_id:(char *)szName
         birth:(char *)szbirth
          sort:(char *)szSort
    completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    [json setValue:[NSString stringWithUTF8String:szName] forKey:@"USER_NAME"];
    [json setValue:[NSString stringWithUTF8String:szbirth] forKey:@"USER_BIRTH"];
    
    NSString * strMethod = [NSString stringWithFormat:@"/find_id/%@",[NSString stringWithUTF8String:szSort]];
    
    
    [[WebServices sharedManager]request:strMethod
                                argment:json
                               complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        [self section:list error:error completion:completeHandler];
    }];
}


-(void)section:(NSArray *)list error:(NSError *) error completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSMutableDictionary * json = [NSMutableDictionary new];
    NSMutableDictionary * subjson = [NSMutableDictionary new];
    NSNumber * number = [NSNumber numberWithUnsignedInteger:([[NSDate date] timeIntervalSince1970] * 1000)];
    
    NSDictionary * dict = [list copy];
    
    for(id key in [dict allKeys])
    {
        if([key isEqualToString:@"data"]){
            [subjson setValue:[dict objectForKey:@"data"]  forKey:@"bundle"];
            break;
        }
        else{
            [subjson setValue:nil forKey:@"bundle"];
        }
    }
    
    [json setValue:@"" forKey:@"senderId"];
    [json setValue:@"" forKey:@"receiverId"];
    [json setValue:number forKey:@"date"];
    
    [subjson setValue:@"MOBILE_CLIENT_SERVICE" forKey:@"service"];
    [subjson setValue:@"RESPONSE" forKey:@"type"];
    
    if(error != nil){
        [subjson setValue:@"Error_client_network_error/server" forKey:@"action"];
        [json setValue:subjson forKey:@"command"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        completeHandler(NO,jsonstr);
        return;
    }
    
    int nStautsCode = [[list valueForKey:@"status_code"]intValue];
    
    if(nStautsCode != 0)
    {
        [subjson setValue:@"Error_client_network_error" forKey:@"action"];
        [json setValue:subjson forKey:@"command"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        completeHandler(NO,jsonstr);
    }
    else
    {
        [subjson setValue:@"Success_client_request" forKey:@"action"];
        [json setValue:subjson forKey:@"command"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString * jsonstr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        completeHandler(YES,jsonstr);
    }
}

@end




