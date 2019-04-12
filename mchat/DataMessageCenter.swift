//
//  RecieveDataManager.swift
//  mchat
//
//  Created by lotawei on 2019/3/30.
//  Copyright © 2019 lotawei. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc public protocol   Serialdatapro:NSObjectProtocol {
    @objc optional func  serialdata() -> Data?

    @objc optional func   unserialdata(_ data:Data) -> [String:Any]?
}

class BaseAuthInfo:NSObject{
    
    let   authcode = "md5xxx"
    let   checknum = "lotawei"
    let  device_id = "ajsdk1askd#!D"
    var messagename = "BaseAuthInfo"
    
}

class  Responseinfo:NSObject,Serialdatapro{
   public   var  code:Int!
   public  var   msg:String!
   public var   bodydata:String!
    public static  func  makeerrresponse(_ code:Int,_ msg:String ) -> Responseinfo{
      let   responseinfo = Responseinfo.init()
        responseinfo.code = code
        responseinfo.msg = msg
        responseinfo.bodydata = ""
        return  responseinfo
        
    }
    func serialdata() -> Data? {
        var  jsonres = [String:Any]()
        jsonres["code"] = code
        jsonres["msg"] = msg
        jsonres["bodydata"] = bodydata
        
        let  json = JSON.init(jsonres)
        do{
            let resdta = try json.rawData()
            return  resdta
        }catch{
            
            return  nil
        }
        
    }
    
}
class UserItemPro:BaseAuthInfo,Serialdatapro {
    var  userid:String = ""
    var  username:String = ""
    var  usericon:String = ""
    var  userlevelvip:String = ""
    var  userphone:String = ""
    
    override init() {
        super.init()
        messagename = "userlogin"
    }
    func serialdata() -> Data? {
        
        var   dicvalue = [String:Any]()
        dicvalue["userid"] = userid
        dicvalue["messagename"] = "userlogin"
        dicvalue["username"] = username
        dicvalue["usericon"] = usericon
        dicvalue["userlevelvip"] = userlevelvip
        dicvalue["userphone"] = userphone
        let  jsondata = JSON.init(dicvalue)
        do{
            let   transdata = try jsondata.rawData()
            return transdata
        }
        catch (let  err){
            
            print(err)
        }
        
        
        return  nil
        
    }
   
    
    func unserialdata(_ data: Data) -> [String:Any]?{
        do {
            let   jsondata = try JSON.init(data: data)
            return jsondata.dictionaryObject
        }catch(let err){
            
            print(err)
            return  nil
        }
        
        
    }
    
    
}

class  DataMessageCenter {
    
    public  static  var  instance = DataMessageCenter()
    
    public  static  func   dealWithMessage(_ data:Data) -> Data?{
        
        do {
            
            let   jsonres = try JSON.init(data: data)
            
            let  messagename =  jsonres["messagename"].string
            
            
            
            
            if  messagename != nil && messagename! == "userlogin" {
              
                guard let  userid = jsonres["userid"].string else{
                    
                    
                    
                    return  Responseinfo.makeerrresponse(10019, "传参错误").serialdata()
                }
                if  userid == "lotawei"{
                    
                    let  newdata = UserItemPro.init()
                    newdata.usericon = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDkTu0DKhDSs8pSvX-mc1rmYVzwHF1qWd5YwPXceSz8Ev3manrMQ"
                    newdata.userid  = userid
                    newdata.userlevelvip = "黄金会员"
                    newdata.userphone = "182387123"
                    newdata.username = "未设置"
                    newdata.messagename = messagename!
                    
                    
                    
                    return  newdata.serialdata()
                    
                }
                else{
                    
                    return   Responseinfo.makeerrresponse(10011, "无此玩家").serialdata()
                }
                
                
                
            }
            
            
            
            
            
            
            
        }   catch (let err){
            
            
            
            return  nil
        }
        return  nil
        
    }
}

