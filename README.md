# SDKDemo

Example
```
//
//  ViewController.m
//  YoseenDemo
//
//  Created by polarbird on 2020/7/4.
//  Copyright © 2020 YoseenIR. All rights reserved.
//

#import "ViewController.h"
#import "YoseenSDK.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    

    //init SDK
    Yoseen_InitSDK();

    //login camera
    YoseenLoginInfo loginInfo = {};
    strcpy(loginInfo.CameraAddr, "192.168.1.60");
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
        float tempFloat = tempShort / slope + offset;
        NSString *tempFloatString = [NSString stringWithFormat:@"%f", tempFloat];
        NSLog(tempFloatString, nil);
        
    } else if(YET_PreviewRecoverBegin == errorCode) {
        // reconnect begins
    } else if(YET_PreviewRecoverEnd == errorCode) {
        // reconnect ends
    }
}

@end

```
# Sceenshot
![Screenshot_1](/doc/screenshot_1.png)
![Screenshot_2](/doc/screenshot_2.png)
