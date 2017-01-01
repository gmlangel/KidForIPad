//  资源包导出工具，可以从任何mac 、ios的项目源码Assets文件夹中导出所有文件
//  AssetsExportTool.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation
class AssetsExportTool:NSObject{
    
    /**
     单例
     */
    static var instance:AssetsExportTool{
        get{
            struct AssetsExportToolStruc{
                static var _ins:AssetsExportTool = AssetsExportTool();
            }
            return AssetsExportToolStruc._ins;
        }
    }
    
    /**
     导出资源
     @param  sourcePath 想导出的资源的位置
     @param  targetPath 导出到哪里
     @param  onComplete 导出成功的回调
     @param  onError  导出失败的回调
     */
    func exportAssetsByPath(_ sourcePath:String,targetPath:String,onComplete:@escaping ()->Void,onError:@escaping (NSError)->Void){
        DispatchQueue.global().async {
            
            //判断路径是否为空字符串，  判断是否是一个合法路径
            var type = self.getFilePathType(sourcePath)
            if type != .directory{
                self.dispatchErrorToMainThread(NSError(domain: "org.gml.err", code: CTErrorEnum.assetsExport_SourcePath_Illegal.rawValue, userInfo: nil), onError: onError);
            }else{
                //判断目标存储路径是否存在，如果不存在则创建
                type = self.getFilePathType(targetPath)
                if type == .no{
                    self.dispatchErrorToMainThread(NSError(domain: "org.gml.err", code: CTErrorEnum.assetsExport_SourcePath_Illegal.rawValue, userInfo: nil), onError: onError);
                }else if type != .directory{
                    //需要创建目录
                    do{
                       try FileManager.default.createDirectory(atPath: targetPath, withIntermediateDirectories: true, attributes: nil)
                    }catch{
                        self.dispatchErrorToMainThread(NSError(domain: "org.gml.err", code: CTErrorEnum.assetsExport_TargetPath_CreateFaild.rawValue, userInfo: nil), onError: onError);
                        return;
                    }
                }
                
                //开始copy文件
                do{
                    let sourceFiles = try FileManager.default.subpathsOfDirectory(atPath: sourcePath)
                    //source目录下包括子目录下的所有文件，将图片copy到target目录中
                    var sP = "";
                    var tP = "";
                    for subPath in sourceFiles{
                        let exten = NSString(string: subPath).pathExtension.lowercased();//取文件的尾缀，判断是否应该copy
                        if exten == "png" || exten == "jpg" || exten == "tiff"{
                            //开始copy
                            do{
                                sP = sourcePath + "/" + subPath;
                                tP = targetPath + "/" + subPath.replacingOccurrences(of: ".imageset/", with: "/")
                                let fileDic = NSString(string: tP).deletingLastPathComponent;
                                if self.getFilePathType(fileDic) != .directory{
                                    //如果路径不存在，则创建这个路径
                                    try FileManager.default.createDirectory(atPath: fileDic, withIntermediateDirectories: true, attributes: nil)
                                }
                                try FileManager.default.copyItem(atPath: sP, toPath: tP);
                            }catch{
                                self.dispatchErrorToMainThread(NSError(domain: "org.gml.err", code: CTErrorEnum.assetsExport_TargetPath_CreateFaild.rawValue, userInfo: nil), onError: onError);
                                return;
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: { 
                        onComplete();//copy完毕
                    })
                }catch{
                    self.dispatchErrorToMainThread(NSError(domain: "org.gml.err", code: CTErrorEnum.assetsExport_TargetPath_CreateFaild.rawValue, userInfo: nil), onError: onError);
                }
            }
            
        }
        
    }
    
    /**
     将错误信息派发到主线程
     */
    fileprivate func dispatchErrorToMainThread(_ err:NSError,onError:@escaping (NSError)->Void){
        DispatchQueue.main.async { 
            onError(err);
        }
    }
    
    /**
     检查某一个路径的类型
     */
    fileprivate func getFilePathType(_ sourcePath:String)->FilePathType{
        var b:ObjCBool = true;
        if sourcePath == ""{
            return FilePathType.no;
        }else if FileManager.default.fileExists(atPath: sourcePath, isDirectory: &b){
            return FilePathType.directory;
        }else{
            return FilePathType.file;
        }
    }
    
}

enum FilePathType:Int32 {
    case no = -1/*空字符串*/
    case file = 0/*文件路径*/
    case directory = 1/*目录路径*/
}
