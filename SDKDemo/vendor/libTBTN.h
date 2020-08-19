#ifndef LIBTBTN_H_
#define LIBTBTN_H_

#include "YoseenTypes.h"

/******************************************************************************
TBTN:
surface temperature to body temperature

*all temperature use "Centigrade unit"

******************************************************************************/
enum TBTNError {
    TBTNError_None = 0,
    TBTNError_InvalidConfig = -1,
    TBTNError_InvalidMea = -2,
};

enum XXXAlarmType {
    XXXAlarmType_None = 0,
    XXXAlarmType_Max,
    XXXAlarmType_MaxMid,
};

struct _TBTNContext;
typedef struct _TBTNContext TBTNContext;

typedef struct _TBTNConfig {
    //alarm
    s32 alarmType;
    float alarmTemp0;
    float alarmTemp1;

    //cvt
    s32 cvtEnable;                //enable, convert surface to body
    float cvtFromMin;            //surfaceTemp min
    float cvtDelta;                //bodyTemp-surfaceTemp
    float cvtToMin;                //bodyTemp min
    float cvtToMax;                //bodyTemp max
}TBTNConfig;

/**************************************************/
typedef struct _XXXMea {
    u16 x0;            //left
    u16 y0;            //top
    u16 x1;            //bottom
    u16 y1;            //right
}XXXMea;

typedef struct _XXXResult {
    float max;        //temp
    u16 maxX;        //x of max temp point
    u16 maxY;        //y of max temp point
    s32 alarm;        //alarmed
}XXXResult;

#define ConstTBTN_TargetCountMax            32
typedef struct _TBTNOutput {
    //input
    s32 inputMeasureCount;                                //input face-mea count
    XXXMea inputMeaArray[ConstTBTN_TargetCountMax];        //input face-mea array

    //output
    s32 galarm;                                            //galarm= OR resultArray
    float gminTemp;                //global min temp
    float gmaxTemp;                //global max temp
    u16 gmaxX;                    //global max x
    u16 gmaxY;                    //global maxy
    XXXResult resultArray[ConstTBTN_TargetCountMax];        //face-result array
}TBTNOutput;

extern "C" {

    /*
    @return alg context
    */
    SDK_API TBTNContext* tbtnCreate();

    /*
    @param pp, alg context
    */
    SDK_API void tbtnFree(TBTNContext** pp);

    /*
    @param context, alg context
    @param config, alg config
    @return error-code
    */
    SDK_API s32 tbtnGetConfig(TBTNContext* context, TBTNConfig* config);

    /*
    @param context, alg context
    @param config, alg config
    @return error-code
    */
    SDK_API s32 tbtnSetConfig(TBTNContext* context, TBTNConfig* config);

    /*
    @param context, alg context
    @param dfh, temp head
    @param dfd, temp body
    @param output, specify faces in input*, get results in resultArray
    @return error-code
    */
    SDK_API s32 tbtnExecute(TBTNContext* context, DataFrameHeader* dfh, s16* dfd, TBTNOutput* output);

};

#endif
