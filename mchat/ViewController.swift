//
//  ViewController.swift
//  mchat
//
//  Created by lotawei on 2019/3/29.
//  Copyright © 2019 lotawei. All rights reserved.
//

import UIKit

struct   UserClient:Codable {
    var  uniqueID:String!
    
    
}
public extension Int {
    /*这是一个内置函数
     lower : 内置为 0，可根据自己要获取的随机数进行修改。
     upper : 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
     返回的结果： [lower,upper) 之间的半开半闭区间的数。
     */
    static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    /**
     生成某个区间的随机数
     */
    static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}

func   RandomServciceTip() -> String{
    let  radoms = ["lisa","miua","najia","mua","enhua","bohua","hjea","iqoo","loa"]
    let index = arc4random()%(UInt32(radoms.count))
    return  radoms[Int(index)]
    
}

class ViewController: UIViewController ,GCDAsyncSocketDelegate{
    @IBOutlet weak var startserver: UIButton!
    
    lazy var   accountsocktes = [GCDAsyncSocket]()
    var  servergoblequene:DispatchQueue!
    var  host = "127.0.0.1"
    var  port:UInt16 = 10013
    var  serverscoket:GCDAsyncSocket!
    var  isstart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        // Do any additional setup after loading the view.
    }
    @IBAction public  func  startserver(_ sender:Any){
        
      
        if !isstart{
        servergoblequene = DispatchQueue.global()
        serverscoket = GCDAsyncSocket.init(delegate: self, delegateQueue:servergoblequene )
        
        do {
            try serverscoket.accept(onPort: port)
            
        }catch {
            print(error)
        }
        }
        isstart = true
        print("服务器已开启")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          
        
        
    }
    func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if   sock == self.serverscoket{
            print("跟这个一样?")
        }
        let account = String.init(data: data, encoding: .utf8)
        let  strtitle = RandomServciceTip()
        let  backmsg = "\(strtitle):\(String(describing: account!)),你好欢迎来到我的聊天室. \n"
        let data = backmsg.data(using: .utf8)
        print("发送消息\(backmsg)")
        sock.write(data!, withTimeout: 3.0, tag: 1)
        sock.readData(withTimeout: -1, tag: 1)
        
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
       
            if self.accountsocktes.contains(sock){
                 print("用户已有相关socket")
                return
            }
            self.accountsocktes.append(newSocket)
            print("\(self.accountsocktes.count)个玩家进入服务器了")
        
        
            newSocket.readData(withTimeout: -1, tag: 1)
        
        
        
    }
    
    
    
    
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        print("客户进来了")
    }
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
          print("我与客户连上了")
        
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
    
  
           print(err?.localizedDescription)
        
           let index = self.accountsocktes.firstIndex(of: sock)
            guard let aindex = index else{
                return
            }
            self.accountsocktes.remove(at: aindex)
            print("\(self.accountsocktes.count)个玩家保持与服务器连接")
            
    
      
        
    }
    
    func  sendMsg(_ data:String){
        
    }
    

}

