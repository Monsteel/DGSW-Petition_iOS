//
//  Preview.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/12.
//

import Foundation

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiView: HomeViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> HomeViewController {
        // 해당 라인을 수정하여 원하는 ViewController를 확인하세요.
        HomeViewController()
    }
}
@available(iOS 13.0, *)
struct ViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ViewControllerRepresentable()
//                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
            
            ViewControllerRepresentable()
//                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            
            ViewControllerRepresentable()
//                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }

    }
} #endif
