//
//  Alamofire_SwiftyJSON.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/24.
//  Copyright © 2019 sam  . All rights reserved.
//SwiftyJSON_HandyJson的使用

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import HandyJSON


// 相当于数据模型model
struct ItemsModel: HandyJSON {
    
    var cover_image_url = ""
    var title  = ""
    var likecount = ""
}

class SwiftyJSON_HandyJson_VC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var gifttableview: UITableView = {
        let tableview: UITableView = UITableView(frame:self.view.bounds, style: .plain)
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 300
        
        return tableview
    }()
    
    // 数据源
    var dataArray = [ItemsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "SwiftyJSON_HandyJson的使用"
        
        self.view.addSubview(gifttableview)
        self.AlamofireGetRequest()
        //self.AlamofirePostRequest()
        //注册cell
        gifttableview.register(SamTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(with: SamTableViewCell.self, for: indexPath)
        let model = self.dataArray[indexPath.row]
        cell.iconImv.kf.setImage(with: URL(string: model.cover_image_url))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         print(indexPath.row)
    }
}

extension SwiftyJSON_HandyJson_VC{

    func AlamofireGetRequest() {
       
        NetworkManager.NetWorkRequest(.getPhotoList, completion: { (JSOnDictory) -> (Void) in//JSOnDictory 是Json类型
            //print(json)
            let dataARR =  JSOnDictory["data"]["items"].arrayObject
            if let arr = JSONDeserializer<ItemsModel>.deserializeModelArrayFrom(array: dataARR) {
                let arr1 = arr.compactMap({$0})
                self.dataArray = arr1
                self.gifttableview.reloadData()
            }
        }) { (errorStr) -> (Void) in
            print(errorStr)
        }
    }

}
