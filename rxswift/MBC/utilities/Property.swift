//
//  Property.swift
//  PrintOrdering
//
//  Created by Tri on 12/4/15.
//  Copyright © 2015 Diadies. All rights reserved.
//

import Foundation
import RxSwift

/**
 Variable is a wrapper for `BehaviorSubject`.
 
 Unlike `BehaviorSubject` it can't terminate with error, and when variable is deallocated
 it will complete it's observable sequence (`asObservable`).
 */
public class Property<Element>: ObservableType {

    // swiftlint:disable:next type_name
    public typealias E = Element

    private let _subject: BehaviorSubject<Element>

    private var _lock = SpinLock()

    // state
    private var _value: E

    /**
     Gets or sets current value of variable.
     
     Whenever a new value is set, all the observers are notified of the change.
     
     Even if the newly set value is same as the old value, observers are still notified for change.
     */
    public var value: E {
        get {
            _lock.lock(); defer { _lock.unlock() }
            return _value
        }
        set(newValue) {
            _lock.lock()
            _value = newValue
            _lock.unlock()

            _subject.on(.next(newValue))
        }
    }

    /**
     Initializes variable with initial value.
     
     - parameter value: Initial variable value.
     */
    public init(_ value: Element) {
        _value = value
        _subject = BehaviorSubject(value: value)
    }

    /**
     - returns: Canonical interface for push style sequence
     */
    public func asObservable() -> Observable<E> {
        return _subject
    }

    public func set(value: E) {
        _lock.lock()
        _value = value
        _lock.unlock()
    }

    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        return _subject.subscribe(observer)
    }

    deinit {
        _subject.on(.completed)
    }
}

protocol Lock {
    func lock()
    func unlock()
}

#if os(Linux)
    import Glibc

    /**
     Simple wrapper for spin lock.
     */
    class SpinLock {
        private var _lock: pthread_spinlock_t = 0

        init() {
            if (pthread_spin_init(&_lock, 0) != 0) {
                queuedFatalError("Spin lock initialization failed")
            }
        }

        func lock() {
            pthread_spin_lock(&_lock)
        }

        func unlock() {
            pthread_spin_unlock(&_lock)
        }

        func performLocked(@noescape action: () -> Void) {
            lock(); defer { unlock() }
            action()
        }

        func calculateLocked<T>(@noescape action: () -> T) -> T {
            lock(); defer { unlock() }
            return action()
        }

        func calculateLockedOrFail<T>(@noescape action: () throws -> T) throws -> T {
            lock(); defer { unlock() }
            let result = try action()
            return result
        }

        deinit {
            pthread_spin_destroy(&_lock)
        }
    }
#else

    // https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20151214/000321.html
    typealias SpinLock = NSRecursiveLock
#endif

extension NSRecursiveLock: Lock {
    func performLocked(_ action: () -> Void) {
        lock(); defer { unlock() }
        action()
    }

    func calculateLocked<T>(_ action: () -> T) -> T {
        lock(); defer { unlock() }
        return action()
    }

    func calculateLockedOrFail<T>(_ action: () throws -> T) throws -> T {
        lock(); defer { unlock() }
        let result = try action()
        return result
    }
}
