//
//  PlaceWebView.swift
//  everyswim
//
//  Created by HeonJin Ha on 12/24/23.
//

import UIKit
import SnapKit
import WebKit

final class PlaceWebViewController: BaseViewController {
    
    private let webView = WKWebView(frame: .zero)
    private let request: URLRequest
    private let indicator = ActivityIndicator(style: .medium)
    
    init(request: URLRequest) {
        self.request = request
        super.init()
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.load(request)
    }
    
    private func configure() {
        webView.navigationDelegate = self
    }
    
    private func layout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension PlaceWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.hide()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.hide()
        presentMessage(title: error.localizedDescription)
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

struct PlaceWebViewController_Previews: PreviewProvider {
    
    static let url = URL(string: "https://google.com")!
    static let request = URLRequest(url: url)
    static let viewController = PlaceWebViewController(request: request)

    static var previews: some View {
        UIViewControllerPreview {
            viewController
        }
        .ignoresSafeArea()
    }
}
#endif
