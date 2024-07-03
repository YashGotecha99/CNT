import UIKit
class ScreenshotManager {
    static var shared = ScreenshotManager()

    private var isScreenshotEnabled = true

    func enableScreenshot() {
        isScreenshotEnabled = true
    }

    func disableScreenshot() {
        isScreenshotEnabled = false
    }

    func isScreenshotEnabledForCurrentViewController() -> Bool {
        if let viewController = topViewController() {
            return viewController.isScreenshotEnabled
        }

        return true
    }

    private func topViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = keyWindow.rootViewController else {
            return nil
        }

        var topViewController: UIViewController? = rootViewController

        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }
}

 

extension UIViewController {
    var isScreenshotEnabled: Bool {
        get {
            return ScreenshotManager.shared.isScreenshotEnabledForCurrentViewController()
        }
        set {
            if newValue {
                ScreenshotManager.shared.enableScreenshot()
            } else {
                ScreenshotManager.shared.disableScreenshot()
            }
        }
    }
}
