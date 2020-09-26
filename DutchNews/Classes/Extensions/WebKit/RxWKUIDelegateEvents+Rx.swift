//
//  RxWKUIDelegateEvents+Rx.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/23/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

import WebKit

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
//swiftlint:disable all
extension Reactive where Base: WKWebView {
    public typealias JSAlertEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: () -> Void)
    public typealias JSConfirmEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: (Bool) -> Void)
    public typealias CommitPreviewEvent = (webView: WKWebView, controller: UIViewController)
    
    /// Reactive wrapper for `navigationDelegate`.
    public var uiDelegate: DelegateProxy<WKWebView, WKUIDelegate> {
        return RxWKUIDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void)`
    public var javaScriptAlertPanel: ControlEvent<JSAlertEvent> {
        typealias __CompletionHandler = @convention(block) () -> Void
        let source: Observable<JSAlertEvent> = uiDelegate
            .methodInvoked(.jsAlert).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject?
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let __completionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__completionBlockPtr, to: __CompletionHandler.self)
                return (view, message, frame, handler)
            }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void)`
    public var javaScriptConfirmPanel: ControlEvent<JSConfirmEvent> {
        typealias __ConfirmHandler = @convention(block) (Bool) -> Void
        let source: Observable<JSConfirmEvent> = uiDelegate
            .methodInvoked(.jsConfirm).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject?
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let __confirmBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__confirmBlockPtr, to: __ConfirmHandler.self)
                return (view, message, frame, handler)
            }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrappper for `func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController)`
    @available(iOS 10.0, *)
    public var commitPreviewing: ControlEvent<CommitPreviewEvent> {
        let source: Observable<CommitPreviewEvent> = uiDelegate
            .methodInvoked(.commitPreviewing)
            .map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let controller = try castOrThrow(UIViewController.self, args[1])
                return (view, controller)
            }
        
        return ControlEvent(events: source)
    }
}

//swiftlint:enable all

fileprivate extension Selector {
    
    static let jsAlert = #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))
    static let jsConfirm = #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))
    @available(iOS 10.0, *)
    static let commitPreviewing = #selector(WKUIDelegate.webView(_:commitPreviewingViewController:))
}
