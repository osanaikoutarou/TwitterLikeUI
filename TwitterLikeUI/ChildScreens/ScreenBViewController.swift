//
//  ScreenBViewController.swift
//  TwitterLikeUI
//
//  Created by osanai on 2019/10/23.
//  Copyright © 2019 長内幸太郎. All rights reserved.
//

import UIKit

class ScreenBViewController: UIViewController, SlideChildViewController  {

    @IBOutlet weak var tableView: UITableView!

    var scrollView: UIScrollView {
        return tableView
    }

    var headerHeight: CGFloat = 0 {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
            tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        }
    }
    
}

extension ScreenBViewController: UITableViewDelegate,UITableViewDataSource {
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

        cell.contentView.backgroundColor = UIColor(red: 0.9, green: 1, blue: 0.9, alpha: 1)

        return cell
    }
}

extension ScreenBViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 親に伝える
        parentVC?.scrollViewDidScroll(viewController: self, scrollView: scrollView)
    }
}
