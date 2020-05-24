//
//  Const.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define kColorGreenDark     (SMInstance.mainColor) // (JXColorHex(0x52BC8E))

#define kHelpLink           (@"http://m.appvworks.com/page/helpInfo.html")
#define kTermLink           (@"http://m.appvworks.com/page/serviceAgreement.html")

//#ifdef JXEnableEnvHoc
//#define kHelpLink           (@"http://m.appvworks.com/test/page/helpInfo.html")
//#define kTermLink           (@"http://m.appvworks.com/test/page/serviceAgreement.html")
//#else
//#define kHelpLink           (@"http://m.appvworks.com/page/helpInfo.html")
//#define kTermLink           (@"http://m.appvworks.com/page/serviceAgreement.html")
//#endif

#ifdef JXEnableEnvApp
#define kCartLink           (@"http://m.appvworks.com/page/shopCar.html")
#define kAddrLink           (@"http://m.appvworks.com/page/locationManage.html")
#define kShopLink           (@"http://m.appvworks.com/page/goodsIndex.html")
#define kOrderLink          (@"http://m.appvworks.com/page/orderClass.html?orderType=%ld")
#define kGoodsLink          (@"http://m.appvworks.com/page/goodsDetails.html?goodsId=%@")
#define kAddrAddLink        (@"http://m.appvworks.com/page/setLocation.html")
#define kYhqMineLink        (@"http://m.appvworks.com/page/saveticket.html")
#define kYhqCenterLink      (@"http://m.appvworks.com/page/savecenter.html")
#define kGoodsDetailLink    (@"http://m.appvworks.com/page/goodsDetails.html?goodsId=%ld_%ld")
#define kGoodsDetailLink2    (@"http://m.appvworks.com/page/goodsDetails.html?goodsId=app_%ld")
#else
#define kCartLink           (@"http://m.appvworks.com/dev/page/shopCar.html")
#define kAddrLink           (@"http://m.appvworks.com/dev/page/locationManage.html")
#define kShopLink           (@"http://m.appvworks.com/dev/page/goodsIndex.html")
#define kOrderLink          (@"http://m.appvworks.com/dev/page/orderClass.html?orderType=%ld")
#define kGoodsLink          (@"http://m.appvworks.com/dev/page/goodsDetails.html?goodsId=%@")
#define kAddrAddLink        (@"http://m.appvworks.com/dev/page/setLocation.html")
#define kYhqMineLink        (@"http://m.appvworks.com/dev/page/saveticket.html")
#define kYhqCenterLink      (@"http://m.appvworks.com/dev/page/savecenter.html")
#define kGoodsDetailLink    (@"http://m.appvworks.com/dev/page/goodsDetails.html?goodsId=%ld_%ld")
#define kGoodsDetailLink2    (@"http://m.appvworks.com/dev/page/goodsDetails.html?goodsId=app_%ld")
#endif


// #define kCartLink           (@"http://www.umeng.com/")
/*************************************************************************
 第三方
 ************************************************************************/
#define kTPPgyAppId             (@"711398407b3e68e5a62829a8fea29ba5")

//#ifdef JXEnableEnvApp
//#define kIMAppId                (@"1400016593")
//#else
//#define kIMAppId                (@"1400016498")
//#endif
#define kIMAccountType          (@"7672")
#define kAMapKey                (@"477b5cebc3908e6efc49b836eb98e8fc")

/*************************************************************************
 存储
 ************************************************************************/
#define kTMCompHistory              (@"kTMCompHistory")
#define kTMCompFavorite             (@"kTMCompFavorite")
#define kTMTestList             (@"kTMTestList")
#define kTMTestQAs             (@"kTMTestQAs")

/*************************************************************************
 通知
 ************************************************************************/
#define kNotifyHistoryDidChange          (@"kNotifyHistoryDidChange")
#define kNotifyMedicineDidRequest       (@"kNotifyMedicineDidRequest")
#define kNotifyMedicineDidBuy           (@"kNotifyMedicineDidBuy")
#define kNotifyFavoriteDidAdd           (@"kNotifyFavoriteDidAdd")
#define kNotifyFavoriteDidDel           (@"kNotifyFavoriteDidDel")
#define kNotifyProfileDidChange           (@"kNotifyProfileDidChange")
#define kNotifyChatDidReceive           (@"kNotifyChatDidReceive")

#define kCaptchaDuration                (60)

#define kAppStoreLink               (@"https://itunes.apple.com/cn/app/jian-kang-zhi-xuan-jian-kang/id1205772594")

#endif /* Const_h */
