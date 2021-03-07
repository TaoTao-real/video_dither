/*
 * @Author: your name
 * @Date: 2020-12-27 15:37:30
 * @LastEditTime: 2020-12-28 17:14:30
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \bmp\bmp_floyddither.cpp
 */

#include <iostream>
#include <vector>

using namespace std;

byte plus_truncate_uchar(byte a, int b) {
    if ((a & 0xff) + b < 0) {
        return 0;
    } else if ((a & 0xff) + b > 255) {
        return (byte) 255;
    } else {
        return (byte) (a + b);
    }
}

int bmp_floyddither(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\lena_floyddither.bmp","wb"))==NULL){
		cout<<"create the bmp file error!"<<endl;
		return -3;
	}
	WORD bfType_w=0x4d42;
	fwrite(&bfType_w,1,sizeof(WORD),fpw);

	strHead.bfSize = 14+40+8+width*height/8;
	strHead.bfOffBits = 14+40+8;
	fwrite(&strHead,1,sizeof(BITMAPFILEHEADER),fpw);
	strInfo.biBitCount = 1;
	strInfo.biClrUsed = 2;
	strInfo.biSizeImage = width*height/8;
	strInfo.biWidth = width;
	strInfo.biHeight = height;
	fwrite(&strInfo,1,sizeof(BITMAPINFOHEADER),fpw);
	//保存调色板数据
	for(unsigned int nCounti=0; nCounti<strInfo.biClrUsed; nCounti++)
	{
		BYTE black = 0, white = 0xff;
		if(nCounti == 0){
			fwrite(&black,1,1,fpw);
			fwrite(&black,1,1,fpw);
			fwrite(&black,1,1,fpw);
			fwrite(&black,1,1,fpw);
		}else{
			fwrite(&white,1,1,fpw);
			fwrite(&white,1,1,fpw);
			fwrite(&white,1,1,fpw);
			fwrite(&white,1,1,fpw);			
		}
	}
    
    vector<int> q_err(512,0);
    int buff_now = 0;
    int old_y = 0;
    int quant_err = 0;
    int err_prepix = 0;
    int err_preline = 0;
	//保存像素数据
	for(int i = height-1; i >= 0; --i){
        err_preline = 0;
        err_prepix = 0;
		for(int j = 0; j < width; j+=8){
            BYTE eightPix = 0;
            for(int k = j; k < j+8; ++k){
                buff_now = plus_truncate_uchar(plus_truncate_uchar(plus_truncate_uchar(imagedata[i][k].rgbBlue, q_err[k]), err_prepix), err_preline);
                //buff_now = byte(byte(imagedata[i][k].rgbBlue) + (q_err[k] + err_prepix + err_preline));
                old_y = buff_now;
                if(buff_now < 128) buff_now = 0;
                else buff_now = 255;
                if(old_y < 0) old_y = 0;
                else if(old_y > 255) old_y = 255;
                quant_err = old_y - buff_now;
                err_prepix = 7*(quant_err>>4);
                err_preline = quant_err>>4;
				if(k-1>=0) q_err[k-1] = plus_truncate_uchar(q_err[k-1],  3*(quant_err>>4));
                //if(k-1>=0) q_err[k-1] += 3*(quant_err>>4);
				q_err[k] = plus_truncate_uchar(q_err[k], 5*(quant_err>>4));
                //q_err[k] += 5*(quant_err>>4);
                if(buff_now == 255){
                    eightPix |= 1<<j+7-k;
                }
            }
			fwrite(&eightPix, 1, 1, fpw);
		}
	}
	fclose(fpw);
	return 0;
}
