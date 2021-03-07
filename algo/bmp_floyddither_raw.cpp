/*
 * @Author: your name
 * @Date: 2020-12-27 18:20:25
 * @LastEditTime: 2020-12-27 19:45:06
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \bmp\bmp_floyddither_raw.cpp
 */

byte plus_truncate_uchar(byte a, int b) {
    if ((a & 0xff) + b < 0) {
        return 0;
    } else if ((a & 0xff) + b > 255) {
        return (byte) 255;
    } else {
        return (byte) (a + b);
    }
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