/*
 * @Author: your name
 * @Date: 2020-12-25 06:55:48
 * @LastEditTime: 2020-12-27 19:07:51
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \bmp\bmp.h
 */
#pragma once

typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef long LONG;
 
//位图文件头定义;
//其中不包含文件类型信息（由于结构体的内存结构决定，
//要是加了的话将不能正确读取文件信息）

typedef struct  BITMAPFILEHEADER{
	//WORD bfType;//文件类型，必须是0x424D，即字符“BM”
	DWORD bfSize;//文件大小
	WORD bfReserved1;//保留字
	WORD bfReserved2;//保留字
	DWORD bfOffBits;//从文件头到实际位图数据的偏移字节数
}BITMAPFILEHEADER;
 
typedef struct BITMAPINFOHEADER{
	DWORD biSize;//信息头大小
	LONG biWidth;//图像宽度
	LONG biHeight;//图像高度
	WORD biPlanes;//位平面数，必须为1
	WORD biBitCount;//每像素位数
	DWORD  biCompression; //压缩类型
	DWORD  biSizeImage; //压缩图像大小字节数
	LONG  biXPelsPerMeter; //水平分辨率
	LONG  biYPelsPerMeter; //垂直分辨率
	DWORD  biClrUsed; //位图实际用到的色彩数
	DWORD  biClrImportant; //本位图中重要的色彩数
}BITMAPINFOHEADER; //位图信息头定义
 
//像素信息
typedef struct IMAGEDATA{
	BYTE blue;
	BYTE green;
	BYTE red;
}IMAGEDATA;
 
typedef struct RGBQUAD{
	BYTE rgbBlue; //该颜色的蓝色分量
	BYTE rgbGreen; //该颜色的绿色分量
	BYTE rgbRed; //该颜色的红色分量
	BYTE rgbReserved; //保留值
	RGBQUAD(BYTE r, BYTE g, BYTE b, BYTE reserve){
		this->rgbRed = r;
		this->rgbGreen = g;
		this->rgbBlue = b;
		this->rgbReserved = reserve;
	}
}RGBQUAD;//调色板定义

typedef unsigned char byte;