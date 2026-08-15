import ScreenSaver
import WebKit

class WebViewScreenSaverView: ScreenSaverView {
    
    private var webView: WKWebView?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupWebView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWebView()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: self.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.width, .height]
        
        // Prevent interaction
        webView.customUserAgent = "ScreenSaver"
        
        self.addSubview(webView)
        self.webView = webView
        
        if let htmlPath = Bundle(for: type(of: self)).path(forResource: "index", ofType: "html") {
            let htmlURL = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        }
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
    }
    
    override func animateOneFrame() {
    }
    
    override var hasConfigureSheet: Bool {
        return false
    }
    
    override var configureSheet: NSWindow? {
        return nil
    }
}
