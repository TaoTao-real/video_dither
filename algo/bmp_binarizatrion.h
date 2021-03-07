/*
 * @Author: your name
 * @Date: 2020-12-25 13:43:23
 * @LastEditTime: 2020-12-25 13:59:44
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \bmp\bmp_binarizatrion.h
 */
#include "bmp.h"
#include <vector>
using namespace std;

int bmp_binarization(BITMAPFILEHEADER& , BITMAPINFOHEADER& , std::vector<std::vector<RGBQUAD> >& , int , int);