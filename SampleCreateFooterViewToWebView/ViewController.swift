//
//  ViewController.swift
//  SampleCreateFooterViewToWebView
//
//  Created by 一騎高橋 on 2016/12/09.
//  Copyright © 2016年 IkkiTakahashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var webView: UIWebView!
    private var footerView: UIView!
    private var associatedHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        self.addWebView()
        self.createFooterView(frame: CGRect(x: 0, y: self.webView.frame.height, width: self.view.frame.width, height: 100))
    }
    
    private func addWebView()
    {
        let statusBarHeight =  UIApplication.shared.statusBarFrame.height
        let url = URL(string : "https://github.com/TakahashiIkki")
        let urlRequest = URLRequest(url: url!)
        
        self.webView = UIWebView(frame: CGRect(origin: CGPoint(x: 0, y: statusBarHeight), size: self.view.frame.size))
        self.webView.loadRequest(urlRequest)
        self.webView.delegate = self
        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
        
        self.view.addSubview(self.webView)
    }
    
    private func createFooterView(frame: CGRect)
    {
        self.footerView = UIView(frame: frame)
        self.footerView.backgroundColor = UIColor.blue
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" && (self.footerView != nil) {
            let newValue = change?[NSKeyValueChangeKey.newKey]
            let newSize = newValue as! CGSize
            let statusBarHeight =  UIApplication.shared.statusBarFrame.height
            
            if (self.associatedHeight == 0 || associatedHeight != newSize.height) {
                let newHeight = newSize.height + self.footerView.frame.size.height + statusBarHeight
                
                if (self.footerView.superview == nil) {
                    self.webView.scrollView.addSubview(self.footerView)
                } else {
                    self.footerView.removeFromSuperview()
                    self.webView.scrollView.addSubview(self.footerView)
                }
                
                self.footerView.frame = CGRect(x: 0, y: newSize.height, width: self.footerView.frame.size.width, height: self.footerView.frame.size.height)
                
                self.associatedHeight = newHeight
                
                self.webView.scrollView.contentSize = CGSize(width: newSize.width, height: newSize.height + self.footerView.frame.size.height + statusBarHeight)
            } else {
                self.associatedHeight = newSize.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
