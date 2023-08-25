//
//  ARViewController.swift
//  Mirage
//
//  Created by fiigmnt on 5/10/22.
//

import ARKit
import RealityKit

class ARViewController: ARView, ARCoachingOverlayViewDelegate {
    let coachingOverlay = ARCoachingOverlayView()

    lazy var frameSize: CGPoint = .init(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)

    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }

    @available(*, unavailable)
    @MainActor @objc dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {}

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        initializeItemsInScene(items)
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
//        configure(restart: true)
    }

    // Sets up the coaching view.
    func setupCoachingOverlay() {
        coachingOverlay.delegate = self
        addSubview(coachingOverlay)
        coachingOverlay.goal = .geoTracking
        coachingOverlay.session = session
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
