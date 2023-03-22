//
//  LifeCycleEventHandler.swift
//  
//
//  Created by Tarek Sabry on 03/02/2023.
//

import UIKit
import SwiftUI

public typealias LifeCycleEventHandler = ((LifeCycleEvent) -> Void)

public enum LifeCycleEvent {
    case viewDidLoad(UIViewController)
    case viewWillAppear(UIViewController)
    case viewDidAppear(UIViewController)
    case viewWillDisappear(UIViewController)
    case viewDidDisappear(UIViewController)
}

struct ViewControllerLifeCycleHandler: UIViewControllerRepresentable {
    
    private let onLifeCycleEvent: LifeCycleEventHandler

    init(onLifeCycleEvent: @escaping LifeCycleEventHandler) {
        self.onLifeCycleEvent = onLifeCycleEvent
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        LifeCycleViewController(onLifeCycleEvent: onLifeCycleEvent)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class LifeCycleViewController: UIViewController {
        private let onLifeCycleEvent: ((LifeCycleEvent) -> Void)
        
        init(onLifeCycleEvent: @escaping LifeCycleEventHandler) {
            self.onLifeCycleEvent = onLifeCycleEvent
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            onLifeCycleEvent(.viewDidLoad(self))
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onLifeCycleEvent(.viewWillAppear(self))
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onLifeCycleEvent(.viewDidAppear(self))
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onLifeCycleEvent(.viewWillDisappear(self))
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            onLifeCycleEvent(.viewDidDisappear(self))
        }
    }
}

public extension View {
    
    func onLifeCycleEvent(perform: @escaping LifeCycleEventHandler) -> some View {
        background(ViewControllerLifeCycleHandler(onLifeCycleEvent: perform))
    }
    
    func onDidLoad(perform: @escaping (() -> Void)) -> some View {
        onLifeCycleEvent { event in
            switch event {
            case .viewDidLoad:
                perform()
                
            default:
                break
            }
        }
    }
    
    func onWillAppear(perform: @escaping (() -> Void)) -> some View {
        onLifeCycleEvent { event in
            switch event {
            case .viewWillAppear:
                perform()
                
            default:
                break
            }
        }
    }
    
    func onDidAppear(perform: @escaping (() -> Void)) -> some View {
        onLifeCycleEvent { event in
            switch event {
            case .viewDidAppear:
                perform()
                
            default:
                break
            }
        }
    }
    
    func onWillDisappear(perform: @escaping (() -> Void)) -> some View {
        onLifeCycleEvent { event in
            switch event {
            case .viewWillDisappear:
                perform()
                
            default:
                break
            }
        }
    }
    
    func onDidDisappear(perform: @escaping (() -> Void)) -> some View {
        onLifeCycleEvent { event in
            switch event {
            case .viewDidDisappear:
                perform()
                
            default:
                break
            }
        }
    }

}
