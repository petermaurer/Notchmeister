//
//  ViewController.swift
//  Notchmeister
//
//  Created by Craig Hockenberry on 10/29/21.
//

import Cocoa

class ViewController: NSViewController {

	var notchWindows: [NotchWindow] = []
	var notchViews: [NotchView] = []
	
    @IBOutlet weak var debugDrawingCheckbox: NSButton!
    
    @IBOutlet weak var fakeNotchCheckbox: NSButton!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForDefaults()
        createNotchWindows()
    }
    
    private func configureForDefaults() {
        debugDrawingCheckbox.state = .off
        fakeNotchCheckbox.state = .off
        
        if Defaults.shouldDebugDrawing {
            debugDrawingCheckbox.state = .on
        }
        
        if Defaults.shouldFakeNotch {
            fakeNotchCheckbox.state = .on
        }
    }
    
    private func createNotchWindows() {
        let padding: CGFloat = 50
        
        for oldWindow in notchWindows {
            oldWindow.orderOut(self)
        }

		for screen in NSScreen.notchedScreens {
			if let notchWindow = NotchWindow(screen: screen, padding: padding) {
				let contentView = NSView(frame: notchWindow.frame)
				contentView.wantsLayer = true;

				if let notchRect = screen.notchRect {
					let contentBounds = contentView.bounds
					let notchFrame = CGRect(origin: CGPoint(x: contentBounds.midX - notchRect.width / 2, y: contentBounds.maxY - notchRect.height), size: notchRect.size)
					let notchView = NotchView(frame: notchFrame)
					contentView.addSubview(notchView)
				}

				notchWindow.contentView = contentView

				notchWindow.orderFront(self)
			}
		}
    }
    
    //MARK: - Actions
    
    @IBAction func debugDrawingValueChanged(_ sender: Any) {
        Defaults.shouldDebugDrawing = (debugDrawingCheckbox.state == .on)
        createNotchWindows()
    }
    
    @IBAction func fakeNotchValueChanged(_ sender: Any) {
        Defaults.shouldFakeNotch = (fakeNotchCheckbox.state == .on)
        createNotchWindows()
    }
}

