# Install

Execute the following

```
carthage checkout --no-use-binaries
```

# Strong reference to Presenter

### Problem

The `Presenter` subscribe to the `Store`. 
The `Store` then keep a reference to the `Presenter` 
in order to notify it when the `AppState` has changed.
However this is a weak reference.
We need to keep a strong reference to the `Presenter` somewhere.

### Solution

Rely on the `ReSwiftRouter` that keep a collection of `Routable` 
while having the `Routable` implemented by 
our module routers (Ex: [RootModule](https://github.com/Viscaweb/reswift-presenter-demo/blob/master/ReSwift%20Example/RootModule.swift)).
These module routers have a strong reference to both the `Presenter` and the `ViewController`.


# UIKit lifecycle & ReSwift

### Problem

The `Presenter` subscribe to the `Store`.
The `Presenter` will be notified by the `Store` about the `AppState`.
However the `Presenter` does not know the current state of the `ViewController`.
Maybe the `ViewController` has not each the `viewDidLoad` state.

### Solution

The `ViewController` could have a public `state` property of `ViewModel` type that
the `Presenter` will change. The `ViewController` will be responsible of observing both
this `state` property and also the `viewLoaded` property. Whenever `state` change and `viewLoaded`
is true, then the render of the view should happen.

# Subsribing & unsubscribing

### Problem

Having too many subscribers can affect performances. Only module that are on screen
should be subscribing.

### Solution [WIP]

Subscribe to a `FeatureStore` from the `ViewController`. This store is not like
the ReSwift store. It would work with the `Presenter` in order to
send to the `ViewController` not the `AppState` but the `ViewModel` it needs.
Subscribing would happen in `viewWillAppear`.
Unsubscribing would happen in `viewWillDisappear`.


