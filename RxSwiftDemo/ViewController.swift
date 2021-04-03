//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 华&梅 on 2020/12/7.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    ///销毁时 清理信号
    var disposeBag: DisposeBag!
    /// 数据源
    let imageIcons = ["晴", "多云", "小雨", "大雨", "雪", "天气-60", "hhxq_1024"];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "测试1"
        
        self.view.backgroundColor = UIColor.blue
        self.disposeBag = DisposeBag()
        
        /// button 点击按钮的实现
        let button = UIButton()
        self.view.addSubview(button)
        button.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        button.backgroundColor = UIColor.white
        button.rx.tap.subscribe(onNext: {
            print("点击发送通知：12231231233")
            
            NotificationCenter.default.post(name: NSNotification.Name.init(NotificationNameDemo1), object: true)
            
        }).disposed(by: disposeBag)
        
        /// UIScollView的滚动的监听
        let view_scroll = UIScrollView()
        self.view.addSubview(view_scroll)
        view_scroll.frame = CGRect(x: button.frame.minX, y: button.frame.maxY+10, width: 100, height: 100)
        view_scroll.backgroundColor = UIColor.white
        view_scroll.contentSize = CGSize(width: 100, height: 400)
        view_scroll.rx.contentOffset.subscribe(onNext: {
            (contentOffset) in
            print("contentOffset->========\(contentOffset)======")
        }).disposed(by: self.disposeBag)
        
        ///通知代理的监听
        NotificationCenter.default
            .rx.notification(Notification.Name.init(NotificationNameDemo1)).subscribe(onNext: {
            (notifi) in
            
            let object = notifi.object
            if object is Bool, let no_true = object {
                print("接受到通知=====\(no_true)===\(notifi.name)=")
            }
            
        }).disposed(by: disposeBag)
        
        ///定时器的实现
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: {
            (num) in
            print("定时器->=====\(num)=====")
        }).disposed(by: disposeBag)
        
        // 1:创建序列
        let ob = Observable<Any>.create { (obserber) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now()+8) {
                ///发送信号
                obserber.onNext("发送信号")
                obserber.onCompleted()
            }
            return Disposables.create()
        }
        
        ///订阅信号
        let _ = ob.subscribe { (text) in
            print("订阅到:\(text)")
        } onError: { (error) in
            print("错误: \(error)")
        } onCompleted: {
            print("完成")
        } onDisposed: {
            print("销毁")
        }

        /// - ===== 更换图标的按钮
        let btn_changeIcon = UIButton()
        self.view.addSubview(btn_changeIcon)
        btn_changeIcon.frame = CGRect(x: view_scroll.frame.minX, y: view_scroll.frame.maxY+20, width: view_scroll.frame.width, height: 40)
        btn_changeIcon.setTitle("更换Icon", for: .normal)
        btn_changeIcon.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn_changeIcon.backgroundColor = UIColor.orange
        btn_changeIcon.rac_signal(for: .touchUpInside)
            .deliverOnMainThread().subscribeNext { [weak self] (x) in
                if let weakSelf = self {
                    if #available(iOS 10.3, *) {
                        let count = Int(arc4random()%(UInt32(weakSelf.imageIcons.count)))
                        let name = weakSelf.imageIcons[count]
                        UIApplication.shared.setAlternateIconName(name) { (error) in
                            print("更换icon图标： ===图片名称：\(name)======错误信息：\(error)==== ")
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let vc = Demo2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

