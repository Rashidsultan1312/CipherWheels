import Foundation
import UIKit
@preconcurrency import WebKit

enum WheelTurn: Equatable {
    case revolved(URL)
    case locked
    case mute
}

enum DiscLedger {
    @MainActor
    static func spin() async -> WheelTurn {
        await RotaProbe().turn()
    }

    static func mask(_ url: URL) -> String {
        var sieve = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
        sieve.fragment = nil
        sieve.scheme = (sieve.scheme ?? "https").lowercased()
        sieve.host = sieve.host?.lowercased()
        var line = sieve.path
        while line.count > 1 && line.hasSuffix("/") { line.removeLast() }
        sieve.path = line
        return sieve.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class RotaProbe: NSObject, WKNavigationDelegate {
    private var waitingFor: CheckedContinuation<WheelTurn, Never>?
    private var dial: WKWebView?
    private var fastened = false
    private var pendulum: Task<Void, Never>?

    func turn() async -> WheelTurn {
        await withCheckedContinuation { handle in
            waitingFor = handle
            let blueprint = WKWebViewConfiguration()
            blueprint.websiteDataStore = .nonPersistent()
            let plate = WKWebView(frame: CGRect(x: 0, y: 0, width: 7, height: 7), configuration: blueprint)
            plate.alpha = 0.015
            plate.navigationDelegate = self
            plate.load(URLRequest(url: AppConfig.cipherLink))
            dial = plate
            pendulum = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 9_800_000_000)
                await MainActor.run { self?.lockIn(.mute) }
            }
        }
    }

    private func lockIn(_ turn: WheelTurn) {
        if fastened { return }
        fastened = true
        pendulum?.cancel()
        dial?.navigationDelegate = nil
        dial?.stopLoading()
        dial = nil
        waitingFor?.resume(returning: turn)
        waitingFor = nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = navigationAction.request.url else {
            decisionHandler(.allow); return
        }
        let stamp = AppConfig.cipherLink
        if DiscLedger.mask(target) != DiscLedger.mask(stamp) {
            decisionHandler(.cancel)
            lockIn(.revolved(target))
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            guard let self = self, !self.fastened else { return }
            self.lockIn(.locked)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error; lockIn(.mute)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error; lockIn(.mute)
    }
}
