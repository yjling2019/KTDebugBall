//
//  KTHttpDocModel.m
//  KTDebugBall
//
//  Created by KOTU on 2022/8/22.
//

#import "KTHttpDocModel.h"

@implementation KTHttpDocListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
	return @{
		@"list" : [KTHttpDocRequestModel class],
	};
}

@end

@implementation KTHttpDocRequestModel

@end
