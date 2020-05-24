//
//  NiceCommentViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

@interface NiceCommentViewController : SLKTextViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) Nice *nice;
@property (nonatomic, copy) JXVoidBlock submitBlock;

@end
