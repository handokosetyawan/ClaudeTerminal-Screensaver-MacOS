import ScreenSaver
import SwiftUI

class NativeScreenSaverView: ScreenSaverView {
    
    private var hostingView: NSHostingView<ClaudeCLIView>?
    private let state = ScreenSaverState()
    private var willStopObserver: NSObjectProtocol?

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let view = ClaudeCLIView(state: state)
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = self.bounds
        hostingView.autoresizingMask = [.width, .height]

        self.addSubview(hostingView)
        self.hostingView = hostingView

        // On macOS 14+, legacyScreenSaver often never calls stopAnimation() and keeps
        // the view alive after the saver is dismissed, so also stop on this notification.
        willStopObserver = DistributedNotificationCenter.default().addObserver(
            forName: NSNotification.Name("com.apple.screensaver.willstop"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.state.stop()
        }
    }

    deinit {
        state.stop()
        if let willStopObserver = willStopObserver {
            DistributedNotificationCenter.default().removeObserver(willStopObserver)
        }
    }

    override func startAnimation() {
        super.startAnimation()
        state.start()
    }

    override func stopAnimation() {
        super.stopAnimation()
        state.stop()
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
