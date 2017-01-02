//  错误码字典
//  ErrorDictionary.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation
enum CTErrorEnum:Int {
    case unknown = -1 /*未知错误*/
    case assetsExport_SourcePath_Illegal = 0/*AssetsExport时source路径不合法*/
    case assetsExport_TargetPath_CreateFaild = 1/*AssetsExport时target路径创建失败*/
    case assetsExport_SourcePath_ForeachFaild = 2/*AssetsExport时source路径遍历失败*/
    case assetsExport_CopyErr = 3/*AssetsExport时Copy发生错误*/
    case pushNotification_Err = 4/*pushNotification的操作系统版本和处理函数不对应*/
    case pushNotification_NullNotifyKey = 5/*pushNotification创建本地推送的时候缺少notify唯一key*/
}
