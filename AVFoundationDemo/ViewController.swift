//
//  ViewController.swift
//  AVFoundationDemo
//
//  Created by 刘靖煌 on 2021/7/12.
//

import UIKit

/// The AVFoundation framework combines six major technology areas that together encompass a wide range of tasks for capturing, processing, synthesizing, controlling, importing and exporting audiovisual media on Apple platforms.
class ViewController: UITableViewController {
    
    lazy var datas: [[String:Any]] = {
        var datas = [[String:Any]]()
        
        datas.append(["title":"音频播放","className":AudioPlayerVC.self])
        
        datas.append(["title":"Capturing","className":CapturingVC.self])
        datas.append(["title":"Processing","className":ProcessingVC.self])
        datas.append(["title":"Synthesizing"])
        datas.append(["title":"Controlling"])
        datas.append(["title":"Importing"])
        datas.append(["title":"Exporting"])
        
        
        return datas
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "AVFoundation-Demo"
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = datas[indexPath.row]
        guard let className = data["className"] as? UIViewController.Type else { return }
        
        let vc = className.init()
        vc.title = data["title"] as? String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = datas[indexPath.row]
        let cellID = NSStringFromClass(UITableViewCell.self)
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = data["title"] as? String
        return cell
    }
    
}
