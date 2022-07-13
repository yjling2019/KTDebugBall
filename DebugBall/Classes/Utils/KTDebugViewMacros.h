//
//  KTDebugViewMacros.h
//  mobile
//
//  Created by KOTU on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#ifndef KTDebugViewMacros_h
#define KTDebugViewMacros_h

#ifndef WEAK_SELF
#define WEAK_SELF __weak typeof(self)wSelf = self;
#endif
#ifndef STRONG_SELF
#define STRONG_SELF __strong typeof(wSelf)self = wSelf;
#endif

#ifndef UserDefaultsSetObjectForKey
#define UserDefaultsSetObjectForKey(obj,key)\
        ({[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]; \
        [[NSUserDefaults standardUserDefaults] synchronize];})
#endif

#ifndef UserDefaultsObjectForKey
#define UserDefaultsObjectForKey(key)\
        ({[[NSUserDefaults standardUserDefaults] objectForKey:key];})
#endif


// 颜色定义
#define RGB(r,g,b)                  [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]
#define RGBA(r,g,b,a)               [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RGB_HEX(hex)                RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),1.f)
#define RGBA_HEX(hex,a)             RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)


#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define animateDuration 0.3
#define statusChangeDuration  5.0
#define normalAlpha  0.8
#define sleepAlpha  0.3
#define gap 10

#endif /* KTDebugViewMacros_h */
