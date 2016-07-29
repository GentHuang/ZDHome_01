//
//  NetworkInterface.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#ifndef ZhiDa_Home_NetworkInterface_h
#define ZhiDa_Home_NetworkInterface_h
/*
 //统一更换接口
 #define MAINURL @"http://183.238.196.216:8088/"
 #define NEWSIMGURL @"http://183.238.196.216:8088/"
 #define IMGURL @"http://183.238.196.216:8088/uploadfiles/images/%@"
 #define TESTMAINURL @"http://183.238.196.216:8088/"
 #define TESTMAINURL @"http://183.238.196.216:8088/"
 #define TESTIMGURL @"http://183.238.196.216:8088/%@"
 #define DESIGNIMGURL @"http://183.238.196.216:8088/uploadfiles/images/%@"
 */
//外网测试地址  （原来的）
//#define MAINURL @"http://www.zhidajj.com:8000/"
//#define TESTMAINURL @"http://zhidao2o.toprand.com.cn/"
//#if 0
////图派测试
//#define NEWSIMGURL @"http://zhidaapi.toprand.com.cn/"
//#define IMGURL @"http://www.zhidao2o.com/uploadfiles/images/%@"
//#define TESTMAINURL @"http://zhidaapi.toprand.com.cn/"
//#define TESTIMGURL @"http://zhidao2o.toprand.com.cn/"
//#define DESIGNIMGURL @"http://zhidao2o.toprand.com.cn/uploadfiles/images/%@"
//#define TESTIMGEURL @"http://zhidao2o.toprand.com.cn%@"
//
//#else
////志达测试
#define NEWSIMGURL @"http://183.238.196.216:8088/"
#define IMGURL @"http://183.238.196.216:8000/uploadfiles/images/%@"
#define TESTMAINURL @"http://183.238.196.216:8088/"
#define TESTIMGURL @"http://183.238.196.216:8000/"
#define DESIGNIMGURL @"http://183.238.196.216:8000/uploadfiles/images/%@"
#define TESTIMGEURL @"http://183.238.196.216:8000%@"
//#endif

// 正式接口
//#define NEWSIMGURL @"http://app2016.zhidajj.com/"
//#define IMGURL @"http://www.zhidajj.com/uploadfiles/images/%@"
//#define TESTMAINURL @"http://app2016.zhidajj.com/"
//#define TESTIMGURL @"http://www.zhidajj.com/"
//#define DESIGNIMGURL @"http://www.zhidajj.com/uploadfiles/images/%@"
//#define TESTIMGEURL @"http://www.zhidajj.com%@"

// 志达布艺
// 获取所有年限
// 例子:http://www.zhidajj.com:8000/theme.ashx?m=yearlist
#define kZhiDaYearAPI TESTMAINURL@"theme.ashx?m=yearlist"
// 每个年限的图片
// 例子:http://www.zhidajj.com:8000/theme.ashx?m=theme&year=2015
#define kZhiDaImageAPI TESTMAINURL@"theme.ashx?m=theme&year=%@"
// 布艺详情
// 例子:http://www.zhidajj.com:8000/space.ashx?m=theme_space&tid=100000067378762
#define kOtherViewAPI TESTMAINURL@"space.ashx?m=theme_space&tid=%@"
// 单品列表
// 例子:http://www.zhidajj.com:8000/space.ashx?m=product_list&sid=100000093213952
#define kSingleListAPI TESTMAINURL@"space.ashx?m=product_list&sid=%@"
// 罗兰德
// 例子:http://www.zhidajj.com:8000/space.ashx?m=luolande
// 玛奇朵
// 例子:http://www.zhidajj.com:8000/space.ashx?m=maqiduo
#define kMNameAPI TESTMAINURL@"space.ashx?m=%@"
// 单品详情
// 例子:http://www.zhidajj.com:8000/product.ashx?m=product&pid=100000302593756
#define kSingleDetailAPI TESTMAINURL@"product.ashx?m=product&pid=%@"
// 获取相关单品
// 例子:http://www.zhidajj.com:8000/product.ashx?m=othercolor&pid=100000162596257&pronumber=MT1002B-30
#define kAllSingleAPI TESTMAINURL@"product.ashx?m=othercolor&pid=%@&pronumber=%@"
// 获取推荐组合
// 例子:http://www.zhidajj.com:8000/product.ashx?m=aboutproduct&aboutproduct=100000162596257
#define kRecommendAPI TESTMAINURL@"product.ashx?m=aboutproduct&aboutproduct=%@"
// 获取空间下载列表
// 例子:http://www.zhidajj.com/inteface/appuser.ashx?m=packageinfo
#define kSceneDownloadListAPI TESTIMGURL@"inteface/appuser.ashx?m=packageinfo"
// 获取布板下载列表
// 例子:http://zhidao2o.toprand.com.cn/inteface/appuser.ashx?m=packageinfo
#define kClothesDownloadListAPI TESTIMGURL@"inteface/appuser.ashx?m=packageinfo"
// 布料列表头部
// 例子:http://www.zhidajj.com:8000/clothlist.ashx?m=type_list
#define kClothesTopViewAPI TESTMAINURL@"clothlist.ashx?m=type_list"
// 布料首页列表
// 例子:http://www.zhidajj.com:8000/clothlist.ashx?m=clothlist_list
#define kClothesFirstPageAPI TESTMAINURL@"clothlist.ashx?m=clothlist_list"
// 布料其他列表
// 例子:http://www.zhidajj.com:8000/cloth.ashx?m=cloth_list&cid=&typeid=102001
#define kClothesOtherPageAPI TESTMAINURL@"cloth.ashx?m=cloth_list&cid=&typeid=%@"
// 布料详情列表(首页用)
// 例子:http://www.zhidajj.com:8000/cloth.ashx?m=cloth_list&cid=100000006993641&typeid=
#define kClothDetailListAPI TESTMAINURL@"cloth.ashx?m=cloth_list&cid=%@&typeid="
// 布料详情
// 例子:http://www.zhidajj.com:8000/cloth.ashx?m=cloth&cid=100001491867875
#define kClothDetailTypeAPI TESTMAINURL@"cloth.ashx?m=cloth&cid=%@"
// 相关布料列表
// 例子:http://www.zhidajj.com:8000/cloth.ashx?m=othercolor&cid=100001491867875
#define kClothDetailTypeOtherAPI TESTMAINURL@"cloth.ashx?m=othercolor&cid=%@"
// 获取资讯头部
// 例子:http://www.zhidajj.com:8000/news.ashx?m=news_type
#define kNewsTitleAPI TESTMAINURL@"news.ashx?m=news_type"
// 获取资讯列表
// 例子:http://www.zhidajj.com:8000/news.ashx?m=news_newslist&tid=100001005
#define kInterNewsDetailAPI TESTMAINURL@"news.ashx?m=news_newslist&tid=%@"
// 获取资讯详情
// 例子:http://www.zhidajj.com:8000/news.ashx?m=news_news&nid=100000028161558
#define kInterNewsAPI TESTMAINURL@"news.ashx?m=news_news&nid=%@"
// 获取DIY空间头部
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_spacetype
#define kDIYSpaceTitleAPI TESTMAINURL@"diy.ashx?m=diy_spacetype"
// 获取DIY风格头部
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_styletype
#define kDIYStyleTitleAPI TESTMAINURL@"diy.ashx?m=diy_styletype"
// 获取DIY列表
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_list&space=104002001&style=104001001
#define kDIYListAPI TESTMAINURL@"diy.ashx?m=diy_list&space=%@&style=%@"
// 获取DIY详情
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_detail&id=3
#define kDIYDetailAPI TESTMAINURL@"diy.ashx?m=diy_detail&id=%@"
// 获取DIY产品替换的列表
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_diyprobytype&id=3&protype=101001001
#define kDIYChangeListAPI TESTMAINURL@"diy.ashx?m=diy_diyprobytype&id=%@&protype=%@"
// 点击替换产品
// 例子:http://zhidaapi.toprand.com.cn/diy.ashx?m=diy_getdiypro&id=103&number=0&olddiyproid=102%7C106%7C104
#define kDIYPressedAPI TESTMAINURL@"diy.ashx?m=diy_getdiypro&id=%@&number=%@&olddiyproid=%@"
// 获取首页DIY信息
// 例子:http://zhidaapi.toprand.com.cn/index.ashx?m=hotdiy
#define kDIYHomePageAPI TESTMAINURL@"index.ashx?m=hotdiy"
// 获取首页设计师信息
// 例子:http://zhidaapi.toprand.com.cn/index.ashx?m=designteam_top3list
#define kDesignerHomePageAPI TESTMAINURL@"index.ashx?m=designteam_top3list"
// 获取设计师Banner
// 例子:http://zhidaapi.toprand.com.cn/designteam.ashx?m=designteam_banner
#define kDesignerBannerAPI TESTMAINURL@"designteam.ashx?m=designteam_banner"
// 获取总设计师
// 例子:http://zhidaapi.toprand.com.cn/designteam.ashx?m=designteam_top1
#define kDesignerTopAPI TESTMAINURL@"designteam.ashx?m=designteam_top1"
// 获取设计师团队
// 例子:http://zhidaapi.toprand.com.cn/designteam.ashx?m=designteam_list
#define kDesignerGroupAPI TESTMAINURL@"designteam.ashx?m=designteam_list"
// 用户登录(m,name,pwd)--POST
// 例子:http://www.zhidajj.com:8000/user.ashx?
#define kUserLoginAPI TESTMAINURL@"user.ashx?"
// 修改密码(m,name,pwd,newpwd)--POST
// 例子:http://www.zhidajj.com:8000/user.ashx?
#define kUserChangePSWAPI TESTMAINURL@"user.ashx?"
// 获取预约单列表
// 例子:http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_list&k=&memberid=6cb9308e-b9db-48c6-b724-ff8d3cdd3e23&pgsize=8&pg=1
#define kGetOrderListAPI TESTMAINURL@"business.ashx?m=bespoke_list&k=&memberid=%@&pgsize=%@&pg=%@"
// 获取预约单详情
// 例子:http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_detail&orderid=20151119145658002
#define kGetOrderDetailAPI TESTMAINURL@"business.ashx?m=bespoke_detail&orderid=%@"
// 获取预约单反馈
// 例子:http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_opinion&orderid=20151111110409005
#define kGetOrderResponseAPI TESTMAINURL@"business.ashx?m=bespoke_opinion&orderid=%@"
// 发送预约单反馈
// 例子:http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_feedback&memberid=6cb9308e-b9db-48c6-b724-ff8d3cdd3e23&orderid=20151119145658002&remarks=%E6%88%91%E5%BE%88%E8%B5%9E
#define kSendResponseAPI TESTMAINURL@"business.ashx?m=bespoke_feedback&memberid=%@&orderid=%@&remarks=%@"
// 获取日志
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_log&orderid=20151119145658002
//获取预约单日志
#define kGetBespokeLogInfoAPI TESTMAINURL@"business.ashx?m=bespoke_log&orderid=%@"
//获取设计单日志
//例子：http://zhidaapi.toprand.com.cn/business.ashx?m=design_log&orderid=20151222160550002
#define kGetDesinLogInfoAPI TESTMAINURL@"business.ashx?m=design_log&orderid=%@"
//获取商品日志
//例子：http://zhidaapi.toprand.com.cn/business.ashx?m=shop_log&orderid=20151225164829001
#define kGetShopLogInfoAPI TESTMAINURL@"business.ashx?m=shop_log&orderid=%@"
// 获取设计单列表
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=design_list&k=&memberid=78adf50a-17d4-490f-b643-0ef2ea449c37
//#define kGetDesignListAPI TESTMAINURL@"business.ashx?m=design_list&k=&memberid=%@"
#define kGetDesignListAPI TESTMAINURL@"business.ashx?m=design_list&k=&memberid=%@&pg=%ld&pgsize=15"
// 获取设计单详情
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=design_detail&orderid=20151106160435004
#define kGetDesignDetailAPI TESTMAINURL@"business.ashx?m=design_detail&orderid=%@"
// 获取中途意见
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=design_opinion&orderid=20150820174327002
#define kGetSuggestAPI TESTMAINURL@"business.ashx?m=design_opinion&orderid=%@"
// 获取设计方案详情
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=designplan_space&plan=DP20150831134216947&itemid=
#define kGetDesignMethodAPI TESTMAINURL@"business.ashx?m=designplan_space&plan=%@&itemid=%@"
// 获取设计方案产品清单
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=designplan_proinfo&plan=DP20150831134216947
#define kGetDesignMethodProListAPI TESTMAINURL@"business.ashx?m=designplan_proinfo&plan=%@"
// 获取设计方案列表
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=designplan_list&memberid=78adf50a-17d4-490f-b643-0ef2ea449c37
//#define kGetDesignMethodListAPI TESTMAINURL@"business.ashx?m=designplan_list&memberid=%@"
#define kGetDesignMethodListAPI TESTMAINURL@"business.ashx?m=designplan_list&memberid=%@&pg=%ld&pgsize=15"
// 获取商品订单列表
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=shop_list&k=&memberid=6CB9308E-B9DB-48C6-B724-FF8D3CDD3E23
//#define kGetProductListAPI TESTMAINURL@"business.ashx?m=shop_list&k=&memberid=%@"
#define kGetProductListAPI TESTMAINURL@"business.ashx?m=shop_list&k=&memberid=%@&pg=%ld"
// 获取商品订单详情
// 例子: http://zhidaapi.toprand.com.cn/business.ashx?m=shop_detail&orderid=20151110112506007
#define kGetProductDetailAPI TESTMAINURL@"business.ashx?m=shop_detail&orderid=%@"
// 获取热门产品(换一换)
// 例子: http://zhidaapi.toprand.com.cn/index.ashx?m=hotproduct&groupid=
#define kGetHotAPI TESTMAINURL@"index.ashx?m=hotproduct&groupid=%@"
// 获取产品分类列表
// 例子: http://zhidaapi.toprand.com.cn/product.ashx?m=news_search
#define kGetSearchListAPI TESTMAINURL@"news.ashx?m=news_search"
//获取商品分类列表
// 例子: http://zhidaapi.toprand.com.cn/product.ashx?m=protypelist
#define kGetSearchProductAPI TESTMAINURL@"product.ashx?m=protypelist"
// 获取热门搜索
// 例子:http://zhidaapi.toprand.com.cn/search.ashx?m=hotsearch_word
#define kGetSearchHotWordAPI TESTMAINURL@"search.ashx?m=hotsearch_word"
// 获取产品搜索列表
// 例子:http://www.zhidajj.com:8000/search.ashx?m=search_product&brand=101004001&style=101003004&space=101002001&type=&keyword=
#define kGetSearchProListAPI TESTMAINURL@"search.ashx?m=search_product&brand=%@&style=%@&space=%@&type=%@&keyword=%@"
// 获取布料搜索列表
// 例子:http://zhidaapi.toprand.com.cn/cloth.ashx?m=search&number=12
#define kGetSearchClothListAPI TESTMAINURL@"cloth.ashx?m=search&number=%@"
// 获取搜索内容
// 例子:
#define kGetSearchClassifyAPI TESTMAINURL@"search.ashx?m=search_product&brand=%@&style=%@&space=%@&type=%@&keyword=%@&order=%@&cloth=%@"
// 获取搜索左边下拉框的第三级数据
#define kGetSearchThirdCellAPI TESTMAINURL@"search.ashx?m=search_product&brand=%@&style=%@&space=%@&type=%@&secondtype=%@&keyword=%@"
// 关于志达
// 例子:http://zhidaapi.toprand.com.cn/search.ashx?m=about
#define kGetAboutAPI TESTMAINURL@"search.ashx?m=about"
// 忘记密码
// 例子:http://zhidao2o.toprand.com.cn/inteface/appuser.ashx?m=getbackpwd&user=%@
#define KForgetPWSendEmail TESTMAINURL@"inteface/appuser.ashx?m=getbackpwd&user=%@"
//头部滚动视图
//例子:http://www.zhidajj.com/uploadfiles/images/2015/6/20150610032010432.jpg
//#define KGetHomePageHearScrollImage @"http://183.238.196.216:8088/index.ashx?m=banner_list"//新接口
#define KGetHomePageHearScrollImage NEWSIMGURL@"index.ashx?m=banner_list"
//客户后续要求修改
//布料头部列表（按年份）
//例子:http://183.238.196.216:8088/clothlist.ashx?m=getallyear
#define KClothesTopViewYearAPI TESTMAINURL@"clothlist.ashx?m=getallyear"
//布料的列表
//列子:http://183.238.196.216:8088/cloth.ashx?m=cloth_list&cid=100000005048437
#define kClothesPlatePageAPI TESTMAINURL@"cloth.ashx?m=cloth_list&cid=%@"
//布板首页的所有布料
//例子:http://183.238.196.216:8088/clothlist.ashx?m=clothlist_list&typeid=
#define kClothesFirstAllPageAPI TESTMAINURL@"clothlist.ashx?m=clothlist_list&typeid="

// 后续增加的APP更新提醒接口
// 例子：http://183.238.196.216:8000/inteface/appuser.ashx?m=version
#define kUpdateAppRemindAPI TESTIMGURL@"inteface/appuser.ashx?m=version"
// 布用途的icon的API
// http://183.238.196.216:8088/cloth.ashx?m=gettypelistbyclothid&cid=100002074276212
#define kClothUseIconAPI TESTMAINURL@"cloth.ashx?m=gettypelistbyclothid&cid=%@"

#endif
