//
//  KTDebugNetworkUtils.h
//  KTDebugBall
//
//  Created by KOTU on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import "KTHttpLogModel.h"
#import "KTHttpDocModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KTDebugNetworkUtils <NSObject>

@optional
+ (nullable NSString *)businessErrorOfRequest:(KTHttpLogModel *)model;
+ (nullable NSString *)apiJsonFileUrl;
+ (nullable NSString *)apiBasicPath;
+ (NSArray *)filterDocModels:(NSArray <KTHttpDocListModel *> *)models;

@end

NS_ASSUME_NONNULL_END
