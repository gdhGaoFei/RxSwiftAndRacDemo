//
//  Demo2ViewController.swift
//  RxSwiftDemo
//
//  Created by 华&梅 on 2020/12/14.
//

import UIKit

class Demo2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试2"
        self.view.backgroundColor = UIColor.purple

        // Do any additional setup after loading the view.
        
        /// button 点击按钮的实现
        let button = UIButton()
        self.view.addSubview(button)
        button.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        button.backgroundColor = UIColor.white
        let _ =  button.rac_signal(for: .touchUpInside)
            .deliverOnMainThread().subscribeNext { [weak self] (sender) in
                if let weakSelf = self {
                    print("========Demo2ViewController 事件 \(weakSelf)========")
                    NotificationCenter.default.post(name: NSNotification.Name.init(NotificationNameDemo1), object: false)
                }
            }.rac_deallocDisposable
        
        ///监听通知
        NotificationCenter.default.rac_addObserver(forName: NotificationNameDemo1, object: nil)
            .deliverOnMainThread().subscribeNext { [weak self] (notifi) in
            let object = notifi?.object
            if object is Bool, let no_true = object, let weakSelf = self {
                print("demo2中接受到的通知：=====\(no_true)===\(notifi?.name)===\(weakSelf)==")
            }
        }//.rac_deallocDisposable
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let vc = Demo1ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("====dealloc====\(self)======")
    }

}
