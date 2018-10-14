//
//  ViewController.swift
//  TwitterLikeUI
//
//  Created by 長内幸太郎 on 2018/10/11.
//  Copyright © 2018年 長内幸太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    @IBOutlet weak var tableView0: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var barLeftConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [tableView0,tableView1,tableView2,tableView3].forEach {
            $0?.delegate = self
            $0?.dataSource = self
            $0?.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        }
        horizontalScrollView.delegate = self
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let random:Int = Int(arc4random() % 9)
        let text = ["👽","💀","😻","🙀","🤖","🎃","🤟","🐰","🐹"][random]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = text
        
        if tableView == tableView0 {
            cell.contentView.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)
        }
        if tableView == tableView1 {
            cell.contentView.backgroundColor = UIColor(red: 0.9, green: 1, blue: 0.9, alpha: 1)
        }
        if tableView == tableView2 {
            cell.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        }
        if tableView == tableView3 {
            cell.contentView.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.9, alpha: 1)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == self.horizontalScrollView) {
            barLeftConstraint.constant = scrollView.contentOffset.x/4
        }
        else {
            print(scrollView.contentOffset)
            headerTopConstraint.constant = max(-(scrollView.contentOffset.y + 300),-300+50)
        }
    }
    
}

