# EdmodoInterview

Hi Edmodo,

Below are the places I like to highlight about this submission.

General:
MVVM - I've reacently started to adopt this and want to take this time to dig deeper.  Each ViewController and TableViewCell has it's viewModel.  With the exception of the deepest 2 ViewControllers as their function are trvial.

Seperation of Network layer - For the scope of this assignment it was still ok to have the network layer be a singleton.

Dependency Injection - This is also something I'm learning and I've attempted to open as much surface area possible to inject even singletons.

Protocol over inheritance - I've also leverage more protocol as a type check instead of inheritance.


Model:
Unit-Testing(TDD) - I'm also trying to adopt as much Unit-Tesing and TDD patter as possible.  You'll find in the Test file my work during the implementation of the netowrk and model parsing layer.
Dates are stored as Swift Dates instead of strings.

UI:
Auto-layout in storyboard, xib, and programmatically.
Use of UIStackView 
