//
//  TestLog.c
//  RemarkLandMark
//
//  Created by duanhai on 2017/8/14.
//  Copyright © 2017年 duanhai. All rights reserved.
//
#include <stdio.h>
#include <string.h>
#include "TestLog.h"
void printlog(){
    printf("hello world !!!");
};

void NV12_YUV420P(const unsigned char* image_src, unsigned char* image_dst,
                  int image_width, int image_height){
    unsigned char* p = image_dst;
    memcpy(p, image_src, image_width * image_height * 3 / 2);
    const unsigned char* pNV = image_src + image_width * image_height;
    unsigned char* pU = p + image_width * image_height;
    unsigned char* pV = p + image_width * image_height + ((image_width * image_height)>>2);
    for (int i=0; i<(image_width * image_height)/2; i++){
        if ((i%2)==0) *pU++ = *(pNV + i);
        else *pV++ = *(pNV + i);}
}
