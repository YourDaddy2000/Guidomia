# Guidomia

## Version

1.0

## Build and Runtime Requirements
+ Xcode 11.0 or later
+ iOS 13.0 or later

## Configuring the Project

Running the app requires no additional steps to configure the Xcode project. Just build & run the project. 

## About Guidomia

Guidomia - is an application for a handy selection of used cars. It allows users to see the latest car sale offers nearby or nationwide. This includes, but not limits to the following features: 
- autoloading of all available car offers
- filtering results by make
- filtering results by model

Important hints:
- Application has no 3rd-party dependencies

## Application Architecture

The Guidomia project includes iOS app target. Architecture that was used for the app is Model-View-Presenter-Router.

### iOS

The iOS version of Guidomia follows core iOS design principles. It follows the Model-View-Presenter-Router (MVP-R) design pattern and uses modern app development practices including Xib files and Auto Layout. It also uses protocol oriented development with single responsibility and encapsulation principles. In the project, we use only dependency injection and don't use Singleton pattern. This approach allows covering 100% of the business logic code with unit tests.

Here is a brief description of MVP-R components.
#### Model
These are data models of type Codable, that contains information fetched from backend (currently from a local JSON file). Structure & properties will be equivalent to the backend response in most of the cases. These models are later transformed/formatted to UI-Models / Tuples, which are plain objects or compound types, before it can be shown to the users in UI.

#### View
This component represents information in UI. Usually, it is an instance of UIViewController, that is responsible for that. Also, UIViewController should inherit from BaseViewController, to make sure it inherits the common logic & protocol. In MVP-R, View holds a strong reference to Presenter via the protocol, and Presenter keeps a weak reference to View. This approach allows making sure, that when View (UIViewController)  is deallocated, Presenter will be deallocated as well. 

#### Presenter
This component is responsible for business logic handling. The presenter fetches data from the backend, converts it and passes it to the View (UIViewController).
It will have a reference to:
-  An appropriate ServiceAPI to make API calls.
- Presenter is responsible for converting models into UI-Models. 

#### Coordinator
- has a factory method to create ChildViewController component, it's Presenter and an Api Service.
- A Coordinator, that is injected into Presenter, will handle all action, out of Presenter's scope. For example - navigation.
When screen 'Foo' needs to be shown, a Coordinator creates the following: FooController, FooPresenter and the FooApiService. After, it passes all dependencies to FooPresenter (FooController, FooApiService) and itself as FooPresenterDelegateProtocol.
- A top-level Router will conform to Coordinator's delegate protocol and will be injected into Coordinator as a dependency.

#### Router
This component is responsible for navigation within the app. It has a reference to an instance of UINavigationController and is injected into FooCoordinator.
Eventually, when FooPresenter is done with logic in it, or user clicks to proceed to the next screen, FooPresenter will deliver this event back to a Coordinator > Router. Router, as a result, will create new classes for next screen and will push it (Like it was with FooController). The whole idea is to encapsulate the logic of navigation between screens into a Router, and to make sure a Presenter doesn't know about other Presenters. 


Additional components.
#### API class
This component is responsible for making API calls, and it would return an appropriate parsed Model type.

#### Factory Method
It is responsible to create new modules from within the Coordinator. A module would usually include FooController, FooPresenter, FooApiService(if needed). Only FooController would be returned from public API via a protocol like this: FooControllerProtocol.

## Swift Features

The Guidomia code leverages many features unique to Swift, including the following:

#### @IBInspectable

Lets us specify that some parts of a custom UIView subclass should be configurable inside Interface Builder

#### Localizable.string

This file allows to add translation data as key-value pairs for different languages

#### Extensions on Types at Different Layers of a Project

For each data type, we have a separate file for extensions. For example: Extension+UIView.swift.
