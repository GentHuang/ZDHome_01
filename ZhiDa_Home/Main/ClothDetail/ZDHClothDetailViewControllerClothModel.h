//
//  ZDHClothDetailViewControllerClothModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHClothDetailViewControllerClothModel : NSObject
@property (strong, nonatomic) NSString *aboutcloth;
@property (strong, nonatomic) NSString *cloth_color;
@property (strong, nonatomic) NSString *cloth_direction;
@property (strong, nonatomic) id cloth_img;
@property (strong, nonatomic) NSString *cloth_number;
@property (strong, nonatomic) NSString *cloth_status;
@property (strong, nonatomic) NSString *cloth_use;
@property (strong, nonatomic) NSString *cloth_way;
@property (strong, nonatomic) NSString *cloth_width;
@property (strong, nonatomic) NSString *clothdensity;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *part;
@property (strong, nonatomic) NSString *cloth_bandname;

//add
@property (strong, nonatomic) id recoilsize_img;
@property (strong, nonatomic) NSString *cloth_part;
//
@property (strong, nonatomic) NSString *id_conflict;
//回味尺寸图recoilsize_img
//数组
@property (strong, nonatomic) NSMutableArray *aboutbuban;

@end


//添加一个model 字段相同
@interface ZDHClothDetailViewClothPlateModel : NSObject

{
    NSString *_id;
}
@property (strong, nonatomic) NSString *id_conflict;

@property (strong, nonatomic) NSString *aboutcloth;
@property (strong, nonatomic) NSString *cloth_color;
@property (strong, nonatomic) NSString *cloth_direction;
@property (strong, nonatomic) id cloth_img;
@property (strong, nonatomic) NSString *cloth_number;
@property (strong, nonatomic) NSString *cloth_status;
@property (strong, nonatomic) NSString *cloth_use;
@property (strong, nonatomic) NSString *cloth_way;
@property (strong, nonatomic) NSString *cloth_width;
@property (strong, nonatomic) NSString *clothdensity;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *part;
@property (strong, nonatomic) NSString *cloth_part;
//add
@property (strong, nonatomic) id recoilsize_img;


//回味尺寸图recoilsize_img
/*
 "aboutcloth" : null,
 "cloth_color" : "黑色",
 "cloth_density" : "简欧联通",
 "cloth_direction" : "定高",
 "cloth_img" : "",
 "cloth_number" : "",
 "cloth_part" : "88%涤+12%金属丝",
 "cloth_status" : "",
 "cloth_use" : "",
 "cloth_way" : "干洗",
 "cloth_width" : "280CM",
 "id" : "100000021826562",
 "intro" : "",
 "name" : "ZK2402-1A",
 "orders" : "218",
 "recoilsize_img" : ""
 */

@end