/*
 * @Author: your name
 * @Date: 2020-12-24 07:11:50
 * @LastEditTime: 2021-01-08 15:32:24
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings 
 * @FilePath: \bmp\bmp.CPP
 */
#include <stdio.h>
#include "bmp.h"
#include "bmp_binarizatrion.h"
#include "stdlib.h"
#include "math.h"
#include <iostream>
#include <vector>

#define LENGTH_NAME_BMP 30//bmp图片文件名的最大长度
 
using namespace std;
 
int bmp_plaingray_generator(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\plaingray.bmp","wb"))==NULL){
		cout<<"create the bmp file error!"<<endl;
		return -3;
	}
	WORD bfType_w=0x4d42;
	fwrite(&bfType_w,1,sizeof(WORD),fpw);
	strHead.bfSize = 14+40+4+width*height/8;
	strHead.bfOffBits = 14+40+4;
	fwrite(&strHead,1,sizeof(BITMAPFILEHEADER),fpw);
	strInfo.biBitCount = 1;
	strInfo.biClrUsed = 1;
	strInfo.biSizeImage = width*height/8;
	strInfo.biWidth = width;
	strInfo.biHeight = height;
	fwrite(&strInfo,1,sizeof(BITMAPINFOHEADER),fpw);
	//保存调色板数据
	for(unsigned int nCounti=0; nCounti<strInfo.biClrUsed; nCounti++)
	{
		BYTE factor = 0x80;
		if(nCounti == 0){
			fwrite(&factor,1,1,fpw);
			fwrite(&factor,1,1,fpw);
			fwrite(&factor,1,1,fpw);
			fwrite(&factor,1,1,fpw);
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
		for(int j = 0; j < width; j+=8){
            BYTE eightPix = 0;
			fwrite(&eightPix, 1, 1, fpw);
		}
	}
	fclose(fpw);
    return 0;
}

 
int bmp_binarization(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\gray_512.bmp","wb"))==NULL){
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

byte plus_truncate_uchar(byte a, int b) {
    if (a + b < 0) {
        return 0;
    } else if (a + b > 255) {
        return (byte) 255;
    } else {
        return (byte) (a + b);
    }
	/*
    if ((a & 0xff) + b < 0) {
        return 0;
    } else if ((a & 0xff) + b > 255) {
        return (byte) 255;
    } else {
        return (byte) (a + b);
    }
	*/
}

int bmp_floyddither(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\bmp_floyddither.bmp","wb"))==NULL){
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
				buff_now = imagedata[i][k].rgbBlue + q_err[k] + err_prepix;
                //buff_now = plus_truncate_uchar(plus_truncate_uchar(plus_truncate_uchar(imagedata[i][k].rgbBlue, q_err[k]), err_prepix), err_preline);
                //buff_now = byte(byte(imagedata[i][k].rgbBlue) + (q_err[k] + err_prepix + err_preline));
                old_y = buff_now;
                if(buff_now < 128) buff_now = 0;
                else buff_now = 255;
                if(old_y < 0) old_y = 0;
                else if(old_y > 255) old_y = 255;
                quant_err = old_y - buff_now;
                err_prepix = 7*(quant_err>>4);
                err_preline = quant_err>>4;
				if(k-1>=0) q_err[k-1] = q_err[k-1] + 3*(quant_err>>4);
				//if(k-1>=0) q_err[k-1] = plus_truncate_uchar(q_err[k-1],  3*(quant_err>>4));
                //if(k-1>=0) q_err[k-1] += 3*(quant_err>>4);
				q_err[k] = err_preline + 5*(quant_err>>4);
				//q_err[k] = plus_truncate_uchar(q_err[k], 5*(quant_err>>4));
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


int bmp_floyddither_raw(BITMAPFILEHEADER& strHead, BITMAPINFOHEADER& strInfo, vector<vector<RGBQUAD>>& imagedata, int width, int height){
    FILE* fpw;
    if((fpw=fopen("C:\\Users\\mprc\\Desktop\\bmp\\lena_floyddither_raw.bmp","wb"))==NULL){
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
                buff_now = imagedata[i][k].rgbBlue;
                old_y = buff_now;
                if(buff_now < 128) buff_now = 0;
                else buff_now = 255;
                imagedata[i][k].rgbBlue = buff_now;
                quant_err = old_y&0xff - buff_now&0xff;
                
                imagedata[i][k+1].rgbBlue = plus_truncate_uchar(imagedata[i][k+1].rgbBlue, (quant_err*7)>>4);
                if(i>=1){
                    imagedata[i-1][k+1].rgbBlue = plus_truncate_uchar(imagedata[i-1][k+1].rgbBlue, (quant_err*3)>>4);
                    imagedata[i-1][k].rgbBlue = plus_truncate_uchar(imagedata[i-1][k].rgbBlue, (quant_err*5)>>4);
                    imagedata[i-1][k-1].rgbBlue = plus_truncate_uchar(imagedata[i-1][k-1].rgbBlue, (quant_err)>>4);
                }
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
 
//变量定义
BITMAPFILEHEADER strHead;
vector<RGBQUAD> strPla(256, RGBQUAD(0,0,0,0));//256色调色板
BITMAPINFOHEADER strInfo;
 
//显示位图文件头信息
void showBmpHead(BITMAPFILEHEADER pBmpHead){
	cout<<"bmp head:"<<endl;
	cout<<"file size:"<<pBmpHead.bfSize<<endl;
	cout<<"reserve word1:"<<pBmpHead.bfReserved1<<endl;
	cout<<"reserve word2:"<<pBmpHead.bfReserved2<<endl;
	cout<<"data offset:"<<pBmpHead.bfOffBits<<endl<<endl;
}
 
void showBmpInforHead(BITMAPINFOHEADER pBmpInforHead){
	cout<<"bmp info:"<<endl;
	cout<<"bmp info size:"<<pBmpInforHead.biSize<<endl;
	cout<<"width:"<<pBmpInforHead.biWidth<<endl;
	cout<<"height:"<<pBmpInforHead.biHeight<<endl;
	cout<<"biPlane:"<<pBmpInforHead.biPlanes<<endl;
	cout<<"biBitCount:"<<pBmpInforHead.biBitCount<<endl;
	cout<<"compression:"<<pBmpInforHead.biCompression<<endl;
	cout<<"biSizeImage:"<<pBmpInforHead.biSizeImage<<endl;
	cout<<"X pixpermeter:"<<pBmpInforHead.biXPelsPerMeter<<endl;
	cout<<"Y pixpermeter:"<<pBmpInforHead.biYPelsPerMeter<<endl;
	cout<<"color used:"<<pBmpInforHead.biClrUsed<<endl;
	cout<<"important color:"<<pBmpInforHead.biClrImportant<<endl;
}
 
int main(){
	
	char strFile[LENGTH_NAME_BMP];//bmp文件名
	int width,height;//图片的宽度和高度

	FILE *fpi;
	fpi=fopen("C:\\Users\\mprc\\Desktop\\bmp\\lena512.bmp","rb");
	if(fpi == NULL){
		cout<<"file open error!"<<endl;
		return -2;
	}
	//先读取文件类型
	WORD bfType;
	fread(&bfType,1,sizeof(WORD),fpi);
	if(0x4d42!=bfType)
	{
		cout<<"the file is not a bmp file!"<<endl;
		return -1;
	}
	//读取bmp文件的文件头和信息头
	fread(&strHead,sizeof(BITMAPFILEHEADER),1,fpi);
	//showBmpHead(strHead);//显示文件头
	fread(&strInfo,sizeof(BITMAPINFOHEADER),1,fpi);
	//showBmpInforHead(strInfo);//显示文件信息头

	//读取调色板
	for(unsigned int nCounti=0; nCounti<strInfo.biClrUsed; nCounti++)
	{
		fread((char *)&(strPla[nCounti].rgbBlue),1,sizeof(BYTE),fpi);
		fread((char *)&(strPla[nCounti].rgbGreen),1,sizeof(BYTE),fpi);
		fread((char *)&(strPla[nCounti].rgbRed),1,sizeof(BYTE),fpi);
		fread((char *)&(strPla[nCounti].rgbReserved),1,sizeof(BYTE),fpi);
	}

	width = strInfo.biWidth;
	height = strInfo.biHeight;
	vector<vector<RGBQUAD>> imagedata(height, vector<RGBQUAD>(width, RGBQUAD(0,0,0,0)));

	for(int i = height-1; i >= 0; --i){
		for(int j = 0; j < width; ++j){
			BYTE pix;
			fread(&pix, 1, 1, fpi);
			imagedata[i][j].rgbBlue = pix;
			imagedata[i][j].rgbGreen = pix;
			imagedata[i][j].rgbRed = pix;
			imagedata[i][j].rgbReserved = 0;
		}
	}
	// 生成纯灰度图像
	//bmp_plaingray_generator(strHead, strInfo, imagedata, width, height);
	// 生成二值化bmp图像
	bmp_floyddither(strHead, strInfo, imagedata, width, height);
	//bmp_binarization(strHead, strInfo, imagedata, width, height);
	//bmp_floyddither_raw(strHead, strInfo, imagedata, width, height);
	return 0;
}