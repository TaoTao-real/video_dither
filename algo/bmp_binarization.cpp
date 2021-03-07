/*
 * @Author: your name
 * @Date: 2020-12-25 13:23:54
 * @LastEditTime: 2020-12-25 13:32:23
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \bmp\bmp_binarization.cpp
 */
#include <iostream>
#include <vector>
#include <bmp.h>
using namespace std;

int bmp_binarization(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\lena_binarization.bmp","wb"))==NULL){
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
	//保存像素数据
	for(int i = height-1; i >= 0; --i){
		for(int j = 0; j < width; j+=8){
			BYTE eightPix = 0;
			if(imagedata[i][j].rgbBlue > 128){
				eightPix|=1<<7;
			}
			if(imagedata[i][j+1].rgbBlue > 128){
				eightPix|=1<<6;
			}
			if(imagedata[i][j+2].rgbBlue > 128){
				eightPix|=1<<5;
			}
			if(imagedata[i][j+3].rgbBlue > 128){
				eightPix|=1<<4;
			}
			if(imagedata[i][j+4].rgbBlue > 128){
				eightPix|=1<<3;
			}
			if(imagedata[i][j+5].rgbBlue > 128){
				eightPix|=1<<2;
			}
			if(imagedata[i][j+6].rgbBlue > 128){
				eightPix|=1<<1;
			}
			if(imagedata[i][j+7].rgbBlue > 128){
				eightPix|=1;
			}
			fwrite(&eightPix, 1, 1, fpw);
		}
	}
	fclose(fpw);
    return 0;
}