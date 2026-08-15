import ScreenSaver
import SwiftUI

class NativeScreenSaverView: ScreenSaverView {
    
    private var hostingView: NSHostingView<ClaudeCLIView>?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let view = ClaudeCLIView()
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = self.bounds
        hostingView.autoresizingMask = [.width, .height]
        
        self.addSubview(hostingView)
        self.hostingView = hostingView
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
