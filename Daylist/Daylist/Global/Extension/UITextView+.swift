//
//  UITextView+.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/11.
//


import UIKit

extension UITextView {
    /// setTextViewToViewer - textView를 드래그 불가 뷰어용으로 설정
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    
    /// setPadding - Daylist textView 기본 padding값 설정
    func setPadding() {
        self.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    /// setTextViewPlaceholder - textView의 placeholder을 지정해주는 함수, delegate와 함께 사용
    func setTextViewPlaceholder(_ placeholder: String) {
        if text == "" {
            text = placeholder
            textColor = UIColor.lightGray
        }
    }
}
