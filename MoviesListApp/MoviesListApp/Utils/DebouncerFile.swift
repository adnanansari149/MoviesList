//
//  DebouncerFile.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 14/07/24.
//

import Foundation

// created Debouncer class for debounce technique with DispatchWorkItem. It is used to create a delay for search result api call instead of api call on every key stroke.
class Debouncer {
    
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
