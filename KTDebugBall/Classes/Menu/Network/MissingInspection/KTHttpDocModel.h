//
//  KTHttpDocModel.h
//  KTDebugBall
//
//  Created by KOTU on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@class KTHttpDocListModel;
@class KTHttpDocRequestModel;

NS_ASSUME_NONNULL_BEGIN

@interface KTHttpDocListModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <KTHttpDocRequestModel *> *list;

@property (nonatomic, assign) BOOL isOpen;

@end

@interface KTHttpDocRequestModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *path;

@property (nonatomic, assign) BOOL checked;

@end

NS_ASSUME_NONNULL_END
