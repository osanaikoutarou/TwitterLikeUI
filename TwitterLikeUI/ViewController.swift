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
    
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var barLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!

    var headerHeight: CGFloat {
        return headerHeightContraint.constant
    }
    var barHeight: CGFloat {
        return barHeightConstraint.constant
    }

    var isViewDidAppear: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalScrollView.delegate = self
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width/2

        screenWidthConstraint.constant = view.bounds.width
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = viewDidLayoutSubViewsFirstTime
    }

    /// 1回だけ呼ばれる
    lazy var viewDidLayoutSubViewsFirstTime: (() -> Void)? = {
        // 各画面のTableViewにHeaderの高さを教える
        children.forEach { (vc) in
            if let vc = vc as? SlideChildViewController {
                vc.headerHeight = headerHeight
            }
        }
        return nil
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
    }
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // バーの位置
        barLeftConstraint.constant = scrollView.contentOffset.x/4
    }
    
}

extension ViewController {
    /// これは各画面から呼ばれる
        func scrollViewDidScroll(viewController: UIViewController, scrollView: UIScrollView) {
            guard isViewDidAppear else {
                return
            }

            // めんどくさい計算
            // Twitterでは上部に残す部分が少し違います（Navigation分残している）
            let scrollWithContentInset = scrollView.contentOffset.y + scrollView.contentInset.top
            let safeAreaTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            headerTopConstraint.constant = min(0,
                                               max(-headerHeight + barHeight + safeAreaTop,
                                                   -scrollWithContentInset))

            // 他の画面のscrollViewをリセット（挙動はTwitterを確認するとわかります）
            for chr in children where chr != viewController {
                if let vc = chr as? SlideChildViewController {
                    vc.scrollView.contentOffset = CGPoint(x: 0, y: min(scrollView.contentOffset.y, -barHeight))
                }
            }
        }
}

/// スライドする各画面が対応すべきprotocol
protocol SlideChildViewController: UIViewController {
    /// scrollViewを持っている
    var scrollView: UIScrollView { get }
    /// tableViewの上のinsetのために必要
    var headerHeight: CGFloat { get set }
    /// ViewControllerを得る共通機能
    var parentVC: ViewController? { get }
}
extension SlideChildViewController {
    var parentVC: ViewController? {
        if isViewLoaded {
            // viewの構成に依存している
            return view.superview?.viewController as? ViewController
        }
        else {
            return nil
        }
    }
}

extension UIView {
    /// viewから所属しているviewControllerを得る
    var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
