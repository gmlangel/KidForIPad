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
    case AssetsExport_SourcePath_Illegal = 0/*AssetsExport时source路径不合法*/
    case AssetsExport_TargetPath_CreateFaild = 1/*AssetsExport时target路径创建失败*/
    case AssetsExport_SourcePath_ForeachFaild = 2/*AssetsExport时source路径遍历失败*/
    case AssetsExport_CopyErr = 3/*AssetsExport时Copy发生错误*/
}