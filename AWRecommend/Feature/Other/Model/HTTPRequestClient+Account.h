//
//  HTTPRequestClient+Account.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient.h"
#import "Favorite.h"
#import "ScanRecord.h"
#import "Doctor.h"
#import "ChatHistory.h"
#import "ChatHistoryList.h"
#import "ShortcutName.h"
#import "ShortcutSymptom.h"

@interface HTTPRequestClient (Account)
- (RACSignal *)getCode:(NSString *)mobile;
- (RACSignal *)exitLogin;
- (RACSignal *)login:(NSString *)mobile code:(NSString *)code weChatOpenid:(NSString *)weChatOpenid;
- (RACSignal *)addDrugFavorite:(NSInteger)brandId;
- (RACSignal *)deleteDrugFavorite:(NSInteger)brandId;
- (RACSignal *)findDrugFavoriteList;
- (RACSignal *)findWiseAccountInfoByOpenId:(NSString *)openId;
- (RACSignal *)addSuggestion:(NSString *)content;
- (RACSignal *)findWiseAccountDetails;
- (RACSignal *)modifyWiseAccountInfo:(NSString *)nickName dateOfBirth:(NSString *)dateOfBirth sex:(GenderType)sex;
- (RACSignal *)modifyWiseAccountHeadImg:(UIImage *)imgFile;
- (RACSignal *)wxLogin:(NSString *)avatar
                  code:(NSString *)code
          isWeChatBind:(NSInteger)isWeChatBind
                mobile:(NSString *)mobile
              nickName:(NSString *)nickName
                   sex:(GenderType)sex
          weChatOpenid:(NSString *)weChatOpenid;
- (RACSignal *)getUserCodeLogs;
- (RACSignal *)userRomoveCodeLog:(NSString *)uid;
- (RACSignal *)doctorsCustomersList;
- (RACSignal *)userAdvisoryRecordWithDoctorId:(NSString *)doctorId currentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize;
- (RACSignal *)searchThroughDrug;
- (RACSignal *)searchThroughDisease;

@end




