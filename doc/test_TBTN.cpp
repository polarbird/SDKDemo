#include "main.h"

#include "YoseenSDK/libTBTN.h"
#include "YoseenSDK/YoseenTypes.h"
#include "YoseenSDK/YoseenSDK.h"
#include "YoseenSDK/YoseenPlayback.h"

#define ConstFnFrame    "d:\\000_data\\person.jpg"

void test_TBTN() {
    /*
    get frame from file, for test

    you can test realtime frames
    */
    s32 ret = Yoseen_InitSDK();
    YoseenPlaybackContext* ypc = YoseenPlayback_Create();
    ret = YoseenPlayback_OpenFile(ypc, ConstFnFrame, xxxmediafile_jpgx);
    DataFrame dataFrame;
    ret = YoseenPlayback_ReadFrame(ypc, 0, &dataFrame);
    DataFrameHeader* dfh = (DataFrameHeader*)dataFrame.Head;
    s16* dfd = (s16*)dataFrame.Temp;

    //create alg, set config
    TBTNContext* ctx = tbtnCreate();
    TBTNConfig config = {};

    config.alarmTemp0 = 37.2f;
    config.alarmTemp1 = 42.0f;
    config.alarmType = XXXAlarmType_Max;

    config.cvtEnable = 1;
    config.cvtDelta = 0.5f;
    config.cvtFromMin = 31.0f;
    config.cvtToMin = 35.5f;
    config.cvtToMax = 36.5f;
    ret = tbtnSetConfig(ctx, &config);

    /*
    we DON'T detect faces, you NEED to implement.
    we JUST measure the faces for you.
    */
    TBTNOutput output = {};
    output.inputMeasureCount = 1;
    XXXMea& mea = output.inputMeaArray[0];
    mea.x0 = 50;
    mea.x1 = 100;
    mea.y0 = 60;
    mea.y1 = 160;

    ret = tbtnExecute(ctx, dfh, dfd, &output);

    //free alg
    tbtnFree(&ctx);

}
