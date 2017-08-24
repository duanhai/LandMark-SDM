//
//  TestLog.h
//  RemarkLandMark
//
//  Created by duanhai on 2017/8/14.
//  Copyright © 2017年 duanhai. All rights reserved.
//

#ifndef TestLog_h
#define TestLog_h

#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif
    void printlog();
    void nv12_YUV420P(const unsigned char* image_src, unsigned char* image_dst,
                      int image_width, int image_height);
#ifdef __cplusplus
}
#endif

#endif /* TestLog_h */
