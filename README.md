This project show the issue of Presenter getting deallocated because their is not strong reference to it.

### Expecting behaviour

- The View show "Hi!"
- Tap on "Say hi!"
- The View show "Bye!"

### Actual behaviour

- The View show "Label"
- Tap on "Say hi!"
- Nothing happen

To fix the issue, you can uncomment the line in `GreetingModuleFactory.swift` that pass the presenter to the view controller.
