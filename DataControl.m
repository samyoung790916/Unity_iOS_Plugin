//
//  DataControl.m
//  quickObjc_sample
//
//  Created by samyoung79 on 13/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import "DataControl.h"
#import "QMChatService.h"
#import "QMServicesManager.h"

@implementation WebServices

NSString * baseUrl = @"http://35.244.21.255:8080/";

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
-(void)request:(NSString *)operation argment:(NSDictionary *)params complete:(void (^)(NSArray * list, NSError * error))completeHandler{

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

-(NSArray *)methodUsingJsonFromSuccessBlock:(NSData *)data{

    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    return jsonArray;
}
@end


typedef void(^CompleteHandler)(BOOL success, NSString * _Nullable errorMessage);

@interface DataControl ()<QMChatServiceDelegate>
@property(strong,nonatomic)CompleteHandler completeHander;


@end

@implementation DataControl

const NSUInteger kApplicationID = 75783;
NSString *const kAuthKey        = @"AUQgNL8EKQRzgK2";
NSString *const kAuthSecret     = @"wZOwVHU-QL2BttL";
NSString *const kAccountKey     = @"U8hGuaeL_v6-hK1sfKrN";


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
    
    if(self){
        [QBSettings setApplicationID:kApplicationID];
        [QBSettings setAuthKey:kAuthKey];
        [QBSettings setAuthSecret:kAuthSecret];
        [QBSettings setAccountKey:kAccountKey];
        
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
    
//     if ([self.dialog.ID isEqualToString:dialogID] && message.senderID == self.s) {
//         //   [self.chatDataSource updateMessage:message];
//     }
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
                _completeHander(YES, @"AAA");
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
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}

-(void)join:(char *)email  password:(char *)pw name:(char *)name completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * pwd = [self encodeStringTo64:@(pw)];
    NSDictionary * param = @{@"email":@(email),@"pwd":pwd,@"name":@(name)};
    
    [[WebServices sharedManager]request:@"join/uoplus" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0){
            completeHandler(NO,@"failed");
        }
        else{
            completeHandler(YES,@"success");
        }
    }];
}


-(void)login:(char *)email password:(char *)pw completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSString * pwd = [self encodeStringTo64:@(pw)];
    NSDictionary * param = @{@"email":@(email),@"pwd":pwd};

    [[WebServices sharedManager]request:@"login/uoplus" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {

        if(error == nil){
            
            int nStautsCode = [[list valueForKey:@"status_code"]intValue];
            
            if(nStautsCode != 0){
                completeHandler(NO,[list valueForKey:@"status"]);
                return;
            }
            
            NSDictionary * pDict = [list valueForKey:@"data"];
            self.user_id = [[list valueForKey:@"qb_id"]intValue];
            
            NSString * strpw = [list valueForKey:@"qb_pw"];
            NSString * strEmail = pDict[@"email"];

            QBUUser * user = [QBUUser user];
            user.ID = self.user_id;
            user.password = strpw;
            user.login = strEmail;
            
            [DataControl sharedManager];

            [[QMServicesManager instance]logInWithUser:user completion:^(BOOL success, NSString * _Nullable errorMessage) {
                
                if(success)
                {
                    [[QMServicesManager instance].chatService allDialogsWithPageLimit:10
                                                                   extendedRequest:nil
                                                                    iterationBlock:^(QBResponse * _Nonnull response,
                                                                                     NSArray<QBChatDialog *> * _Nullable dialogObjects,
                                                                                     NSSet<NSNumber *> * _Nullable dialogsUsersIDs,
                                                                                     BOOL * _Nonnull stop){
                        
                        self.dialog = dialogObjects[0];
                        completeHandler(YES,@"success");

                    }completion:^(QBResponse * _Nonnull response) {}];
                }
                else{
                   completeHandler(NO,errorMessage);
                }
            }];
        }
        else{
            self.completeHander(NO, [error localizedDescription]);
        }
    }];
}

-(void)device_connect:(char *)serialNumber completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
    NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:@(serialNumber),@"DEVICE_ID",@"samyoung79@naver.com",@"USER_ID",nil];
    
    [[WebServices sharedManager]request:@"uoplus/connect/device" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0){
            completeHandler(NO,@"failed");
        }else{
            completeHandler(YES,@"success");
        }
        
        
    }];
}

-(void)device_quit:(char *)serialNumber completion:(void (^)(BOOL success, NSString * resultMessage))completeHandler
{
   NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:@(serialNumber),@"DEVICE_ID",@(self.user_id),@"USER_ID",nil];

    [[WebServices sharedManager]request:@"uoplus/quit/chat" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0){
            completeHandler(NO,@"failed");
        }else{
            completeHandler(YES,@"success");
        }

    }];
}

-(void)device_list:(char *)email completion:(void (^)(BOOL success, NSString * resultMessage, NSArray * list))completeHandler // 기기리스트 호출
{
    NSDictionary * param = [[NSDictionary alloc]initWithObjectsAndKeys:@(email),@"USER_ID", nil];
    
    [[WebServices sharedManager]request:@"uoplus/search/device" argment:param complete:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        
        int nStautsCode = [[list valueForKey:@"status_code"]intValue];
        
        if(nStautsCode != 0){
            completeHandler(NO,@"failed", nil);
        }else{
            completeHandler(YES,@"success",[list valueForKey:@"deviceList"]);
        }
    }];
    
}

-(void)sendmessage:(char *)szMessage completion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completeHandler{
    QBChatMessage * message = [QBChatMessage new];
    message.text = @(szMessage);
    message.senderID = [QBSession currentSession].currentUser.ID;
    
    
    self.completeHander = completeHandler;
    

    message.dialogID = self.dialog.ID;
    message.dateSent = [NSDate date];

    [[QMServicesManager instance].chatService sendMessage:message
                                            toDialogID:self.dialog.ID
                                         saveToHistory:YES
                                         saveToStorage:YES
                                            completion:^(NSError * _Nullable error){

                                                if(error != nil){
                                                    self.completeHander(NO, [error localizedDescription]);
                                                }

                                            }];
    
}




@end
