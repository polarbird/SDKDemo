//
//  ViewController.mm
//  YoseenDemo
//
//  Created by polarbird on 2020/7/4.
//  Copyright © 2020 YoseenIR. All rights reserved.
//

#import "ViewController.h"
#import "YoseenSDK.h"
#import "libTBTN.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    

    //init SDK
    Yoseen_InitSDK();

    //login camera
    YoseenLoginInfo loginInfo = {};
    strcpy(loginInfo.CameraAddr, "192.168.1.64");
    CameraBasicInfo basicInfo = {};
    s32 userHandle = Yoseen_Login(&loginInfo, &basicInfo);

    // start temperature stream transport.
    YoseenPreviewInfo previewInfo = {};
    // Set the DataType to temperature stearm
    previewInfo.DataType = xxxdatatype_temp;
    
    // Set the CustomCallback to the name of the static callback function you defind.
    previewInfo.CustomCallback = StaticPreviewCallback;//get every frame data in callback
    
    // Set some other custom data. It can be used in the callback
    // previewInfo.CustomData = ;
    s32 previewHandle = Yoseen_StartPreview(userHandle, &previewInfo);
    
    NSString *ValueString = [NSString stringWithFormat:@"%d", previewHandle];
    NSLog(ValueString, nil);
    
    // Do any additional setup after loading the view.
    
//    TBTNContext* ctx= tbtnCreate();
//    ValueString = [NSString stringWithFormat:@"tbtn ctx %x", ctx];
//    NSLog(ValueString, nil);
    
    
    CtlX ctlx = {};
    s32 ret;
    ExtBbConfig& bbConfig = ctlx.Data.BbConfig;
    
    //Get hsrp config
    ctlx.Type = CtlXType_GetExtBbConfig;
    ret = Yoseen_SendControlX(userHandle, &ctlx);
    printf("enable %d, x %d, y %d, radius %d, temp %d [0.1℃]\n", bbConfig.enable, bbConfig.x, bbConfig.y, bbConfig.radius, bbConfig.temp);
    
    //set hsrp config
    ctlx.Type = CtlXType_SetExtBbConfig;
    bbConfig.x = 192; // 0<x<384, !!!left-top is infrared-image origin, with no transform.
    bbConfig.y = 144; // 0<y<288
    bbConfig.radius = 1;
    bbConfig.temp = 360; //360*0.1 = 36℃, !!!unit is 0.1℃
    bbConfig.enable = 1; //1 enable, 0 disable, !!! all args must be valid, even if you only want to disable hsrp
    ret = Yoseen_SendControlX(userHandle, &ctlx);
    printf("Yoseen_SendControlX returns %d", ret);
}


// Definition of a static callback function.
// The name of this function could be whatever you like.
// The parameters of this function should be as shown here.
void StaticPreviewCallback(s32 errorCode, DataFrame *dataFrame,
                                         void *customData) {
    if (YET_None == errorCode) {
        // Get the DataFrameHeader pointer of this frame
        DataFrameHeader *dfh = (DataFrameHeader *)dataFrame->Head;
        // Get the index of this frame
        // NSString *ValueString = [NSString stringWithFormat:@"%d", dfh->Index];
        // Print the frame index in Console
        // NSLog(ValueString, nil);
        
        // Get the bmp data of this frame
        bgra *bmpInfo = (bgra *)dataFrame->Bmp;
        
        // Get the temperature data of this frame
        s16 *tempData = (s16 *)dataFrame->Temp;
        
        //Print float in Celsius
        u16 slope =dfh->Slope;
        s16 offset = dfh->Offset;
        s16 tempShort = *tempData;
//        float tempFloat = tempShort / slope + offset;
//        NSString *tempFloatString = [NSString stringWithFormat:@"%f", tempFloat];
//        NSLog(tempFloatString, nil);
        
        
        //create alg, set config
//        TBTNContext* ctx = tbtnCreate();
//        TBTNConfig config = {};
//
//        config.alarmTemp0 = 37.2f;
//        config.alarmTemp1 = 42.0f;
//        config.alarmType = XXXAlarmType_Max;
//
//        config.cvtEnable = 1;
//        config.cvtDelta = 0.5f;
//        config.cvtFromMin = 31.0f;
//        config.cvtToMin = 35.5f;
//        config.cvtToMax = 36.5f;
//        s32 ret1 = tbtnSetConfig(ctx, &config);

        /*
        we DON'T detect faces, you NEED to implement.
        we JUST measure the faces for you.
        */
//        TBTNOutput output = {};
//        output.inputMeasureCount = 1;
//        XXXMea& mea = output.inputMeaArray[0];
//        mea.x0 = 50;
//        mea.x1 = 100;
//        mea.y0 = 60;
//        mea.y1 = 160;

//        s32 ret2 = tbtnExecute(ctx, dfh, tempData, &output);
        
//        NSLog(@"tbtn output: ", nil);
//        NSString *gMaxTempString = [NSString stringWithFormat:@"%f", output.gmaxTemp];
//        NSLog(gMaxTempString, nil);
        
        

        //free alg
//        tbtnFree(&ctx);
        
        
    } else if(YET_PreviewRecoverBegin == errorCode) {
        // reconnect begins
    } else if(YET_PreviewRecoverEnd == errorCode) {
        // reconnect ends
    }
}

@end
