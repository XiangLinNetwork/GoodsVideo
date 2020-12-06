//
//  ZhiBoViewController.m
//  WuYeYuanGongDuan
// 13888888888 123456
// http://aimoer.1plus.store/
// http://wiki2.hlsxcx.com/web/#/132?page_id=5894
//  Created by Mac on 2020/12/6.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ZhiBoViewController.h"
#import <TXLiteAVSDK.h>
#import "GenerateTestUserSig.h"

@interface ZhiBoViewController ()<TRTCCloudDelegate,TRTCVideoRenderDelegate>
@property (nonatomic , strong) TRTCCloud *trtc;


@end

@implementation ZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    
    [self drawUI];
    
}

-(void)drawUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton *btchuangjian = [[UIButton alloc] init];
    [btchuangjian setTitle:@"创建" forState:UIControlStateNormal];
    [btchuangjian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btchuangjian];
    [btchuangjian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.top.offset(400);
        make.size.sizeOffset(CGSizeMake(80, 50));
    }];
    [btchuangjian addTarget:self action:@selector(chuangjianAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btguankan = [[UIButton alloc] init];
    [btguankan setTitle:@"观看" forState:UIControlStateNormal];
    [btguankan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btguankan];
    [btguankan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btchuangjian.mas_right).offset(30);
        make.top.offset(400);
        make.size.sizeOffset(CGSizeMake(80, 50));
    }];
    [btguankan addTarget:self action:@selector(guankanAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btshangmai = [[UIButton alloc] init];
    [btshangmai setTitle:@"上麦" forState:UIControlStateNormal];
    [btshangmai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btshangmai];
    [btshangmai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btchuangjian);
        make.top.offset(470);
        make.size.sizeOffset(CGSizeMake(80, 50));
    }];
    [btshangmai addTarget:self action:@selector(shuohuaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btsend = [[UIButton alloc] init];
   [btsend setTitle:@"发送消息" forState:UIControlStateNormal];
   [btsend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   [self.view addSubview:btsend];
   [btsend mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(btshangmai.mas_right).offset(30);
       make.top.offset(470);
       make.size.sizeOffset(CGSizeMake(80, 50));
   }];
   [btsend addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
       
}
///创建
-(void)chuangjianAction
{
   if(self.trtc==nil)
   {
       TRTCCloud *trtc =  [TRTCCloud sharedInstance];
       [trtc setDelegate:self];
       _trtc = trtc;
   }
    
    ///SDKAppID = 1400457020;
    ///SECRETKEY = @"4eb797fe88a3ac64a7c9c774fb7263b3388da042f02c4e259a3a461aeaa5844c";
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = 1400457020;
    params.userId = @"penggj001";
    params.userSig = [GenerateTestUserSig genTestUserSig:@"penggj001"];
    params.roomId = 989789;
    params.role = TRTCRoleAnchor;
    
    
    ///主播端开启摄像头预览和麦克风采音
    TXView *view = [[TXView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:view];
    ///可以开启本地的摄像头预览，SDK 会向系统请求摄像头使用权限。
    [self.trtc startLocalPreview:YES view:view];
    ///可以设定本地视频画面的显示模式
    [self.trtc setLocalVideoRenderDelegate:self pixelFormat:TRTCVideoPixelFormat_Unknown bufferType:TRTCVideoBufferType_PixelBuffer];
    TRTCVideoEncParam *encParams = [[TRTCVideoEncParam alloc] init];
    encParams.videoResolution = TRTCVideoResolution_480_480;
    encParams.videoBitrate    = 1200;
    encParams.videoFps        = 15;
    [self.trtc setVideoEncoderParam:encParams];
    [self.trtc startLocalAudio:TRTCAudioQualityDefault];
    
    ///主播端设置美颜效果
    TXBeautyManager *beautym = [self.trtc getBeautyManager];
    [beautym setBeautyStyle:TXBeautyStyleSmooth];
    [beautym setBeautyLevel:5];
    [beautym setWhitenessLevel:5];
    
    ///主播端创建房间并开始推流
    [self.trtc enterRoom:params appScene:TRTCAppSceneLIVE];///TRTCAppSceneVideoCall
    
}
///观看
-(void)guankanAction
{
    if(self.trtc==nil)
    {
        TRTCCloud *trtc =  [TRTCCloud sharedInstance];
        [trtc setDelegate:self];
        _trtc = trtc;
    }
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = 1400457020;
    params.userId = @"penggj002";
    params.userSig = [GenerateTestUserSig genTestUserSig:@"penggj002"];
    params.roomId = 989789;
    params.role = TRTCRoleAudience;
    [self.trtc enterRoom:params appScene:TRTCAppSceneLIVE];//TRTCAppSceneVideoCall
    ///观看直播
    TXView *view = [[TXView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:view];
    [self.trtc startRemoteView:@"penggj001" streamType:TRTCVideoStreamTypeBig view:view];
    
}

-(void)shuohuaAction:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"上麦"])
    {
        [sender setTitle:@"下麦" forState:UIControlStateNormal];
        [self lianmai];
    }
    else
    {
        [sender setTitle:@"上麦" forState:UIControlStateNormal];
        [self xiamai];
    }
}

///观众上麦
-(void)lianmai
{
    [self.trtc switchRole:TRTCRoleAnchor];
    [self.trtc startLocalAudio:TRTCAudioQualityDefault];
}
///观众下麦
-(void)xiamai
{
    [self.trtc switchRole:TRTCRoleAudience];
    [self.trtc stopLocalAudio];
}
///发送消息
-(void)sendAction
{
    NSString *strvalue = @"消息";
    BOOL send = [_trtc sendCustomCmdMsg:1 data:[strvalue dataUsingEncoding:NSUTF8StringEncoding] reliable:NO ordered:NO];
    NSLog(@"%d",send);
}

#pragma mark - TRTCCloudDelegate
- (void)onError:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg extInfo:(nullable NSDictionary*)extInfo
{
    
    if(errCode == ERR_ROOM_ENTER_FAIL)
    {///进入房间失败退出房间
        [self.trtc exitRoom];
    }
}
///已加入房间的回调
- (void)onEnterRoom:(NSInteger)result
{
    NSLog(@"已加入房间");
}
///离开房间的事件回调
- (void)onExitRoom:(NSInteger)reason
{
    
}
///切换角色的事件回调 切换主播和观众的角色，该操作会伴随一个线路切换的过程，
- (void)onSwitchRole:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg
{
    
}
///切换房间 (switchRoom) 的结果回调
- (void)onSwitchRoom:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg
{
    
}
///有用户加入当前房间
- (void)onRemoteUserEnterRoom:(NSString *)userId
{
    
}
///有用户离开当前房间
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason
{
    
}
///跟服务器的连接断开
- (void)onConnectionLost
{
    
}
///尝试重新连接到服务器
- (void)onTryToReconnect
{
    
}
///跟服务器的连接恢复
- (void)onConnectionRecovery
{
    
}
///收到自定义消息回调 sendCustomCmdMsg 发送自定义消息时
- (void)onRecvCustomCmdMsgUserId:(NSString *)userId cmdID:(NSInteger)cmdID seq:(UInt32)seq message:(NSData *)message
{
    
}
///收到 SEI 消息的回调 sendSEIMsg 发送数据时
- (void)onRecvSEIMsg:(NSString *)userId message:(NSData*)message
{
    NSLog(@"收到消息：%@",[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
}

#pragma mark - TRTCVideoRenderDelegate
- (void) onRenderVideoFrame:(TRTCVideoFrame * _Nonnull)frame userId:(NSString* __nullable)userId streamType:(TRTCVideoStreamType)streamType
{
    
}

@end
