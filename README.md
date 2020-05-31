# Mvi-SwiftUI

If you like to read this on __[Medium](https://medium.com/better-programming/mvi-architecture-for-swiftui-apps-cff44428394)__ , you can find it here __[MVI Architecture for SwiftUI Apps](https://medium.com/better-programming/mvi-architecture-for-swiftui-apps-cff44428394)__

## MVI Architecture ##
Model-View-Intent (MVI) is a popular architecture in the Android world. It was introduced by Hannes Dorfmann. You can find it [here](http://hannesdorfmann.com/android/mosby3-mvi-1). For the purpose of this article, a brief introduction to MVI is presented below.

MVI is a cyclical and unidirectional data-flow architecture.
* _The __Model__ represents the state of the application_. It contains the properties necessary to render the screen.
* _An __Intent__ is an event to change the state of the system_ — e.g., user click is an event to change the state of the system.
* The __View__ observes the state change and updates itself accordingly.

### Graphical Representation
![Graphial representation](https://miro.medium.com/max/1400/1*6i4EBK-J7ZGFQIpQGtpozg.jpeg)

#### Working 
1. The user interacts with the View to create an Intent.
2. The Intent changes the state of the application.
3. A change in state updates the View. The cycle repeats.

__Note__ : Additionally, API and Push notifications also change the state of the application.



## MVI Implementation in SwiftUI

For demonstration purposes, we’ll implement a movie-search screen. It has a `TextField` to type in the keyword to search. Below is the list of movies matching the keyword.

### Model (State of the Application)

First up, let’s consider the possible states of the application. At any given time, the application will be in one of the following states. Later, you’ll see that we have a view for each of the corresponding state.
 
![](https://miro.medium.com/max/1400/1*g82aZqvkzI_PayV9KMP8Bw.jpeg)

* `InitState`: It’s an initial state. Nothing has been queried.
* `Loading`: The keyword has been entered, and movies are being fetched from the API.
* `SuccessfullyFetched` : When the API returns the matching movies.
* `NoMatchingResults`: When no results are found for the query.
* `ApiError`: The HTTP request failed or the API returned an error




We will use Swift’s Enum to hold the states.

```swift
enum SearchPageState {
    case Init
    case Loading(String) // String is the message to be shown while laoding
    case SuccessfullyFetched([Movie]) // List of matching Movies
    case NoResultsFound
    case ApiError(String) // Error message to be shown
}
```


### SearchPageViewModel(Business layer)

* It contains the State of the Application.
* Receives the Intent from the View and updates the State.
* Publishes the updated State to the View.

Let’s see it’s implementation. `SearchPageViewModel` is a data-holder class that holds the state of the application. 
It conforms to the `ObservableObject` protocol. Anything inside the `ObservableObject` protocol can announce when its values have changed so the SwiftUI view can update itself.

It has a variable named `uiState` of the type `SearchPageState`. It’s wrapped with the `Published` property wrapper. This way it can notify the view when its value changes.

This class receives the intent, makes API calls to fetch the data, and updates the state of the application.

`loadMovies` is the function called when there’s an intent to fetch the matching movies. The comments below show how that function is updating the state of the application.

```swift
class SearchPageViewModel : ObservableObject {
    
    @Published var uiState: SearchPageState = .Init
    
    let repository: MovieRepository = MovieRepository()
    
    func loadMovies(query: String) {
        
        // 1. state is changed to Loading
        self.uiState = .Loading("Querying for \(query)")
        repository
            .searchMovies(query: query)
            .subscribe(
                onNext: { [weak self] response in
                    
                    if response.results.count == 0 {
                        // 2. State is updated to NoResultsFound
                        self?.uiState = .NoResultsFound
                    } else {
                        // 3. state is updated to SuccesffullyFetched
                        self?.uiState = .Fetched(response)
                    }
                    
                },
                onError: { error in
                    // 4. state is updated to ApiError
                    self.uiState = .ApiError("Results couldnot be fetched")
            }
        )
    }
}
```

### View

A `TextField` to enter the keyword. Below that, we have a group that shows the view as per the state of the application.

__Dry Run:__  When we the commit (hit the search button), it fires an intent to the SearchPageViewModel to update the state. SearchPageViewModel then makes an API to update the state.

``` Init → Loading → [SuccessfullyFetched | NoResultsFound | ApiError] ```

The group has exhaustive cases of the SearchPageState, a corresponding view for each state of the application.

```swift
struct SearchPageView: View {
    @ObservedObject var vm: SearchPageViewModel
    
    @State private var query: String = ""
    
    init(viewModel: SearchPageViewModel) {
        self.vm = viewModel
    }
    
    
    var body: some View {
        ScrollView {
            
            // Enter the keyword here and when commited fire an Intent to load the movies
            TextField("search movies", text: $query, onCommit: {
                // Fires an Intent to load the movies for the keyword 
                self.vm.loadMovies(query: self.query)
            })
            
            /**
            * It contains the exhaustive cases. It observes the uiState and
            * updates it's view accordingly
            */
            Group { () -> AnyView in
                
                switch vm.uiState {
                
                case .Init:
                    return AnyView(Text("Please type in to query"))
                
                case .Loading(let message):
                    return AnyView(Text(message))
                
                case .SuccessfullyFetched(let movies):
                    // This displays the list of Movies  matching the keyword
                    return AnyView(SearchedMoviesView(movies: movies))
                    
                case .NoResultsFound:
                    return AnyView(Text("No matching movies found"))
                    
                case .ApiError(let errorMessage):
                    return AnyView(Text(errorMessage))
                }
            }
        }
    }
}
```

### Intent

It is an interaction on the View. The intent is propagated to the `SearchPageViewModel` which consequently alters it’s state. Example: Pressing the search icon after entering the query is an Intent to load the matching movies.

``` vm.loadMovies(query: self.query) is an Intent.```

```swift
struct SearchPageView: View {
  ...
  ...
  var body: some View {
    ..
    ..
      // Enter the keyword here and when commited fire an Intent to load the movies
      TextField("search movies", text: $query, onCommit: {
          // Fires an Intent to load the movies for the keyword 
          self.vm.loadMovies(query: self.query)
      })
  }

}
```


## Closing Points

Now that you have an understanding of MVI and it’s implementation, we’ll see why is this relevant for SwiftUI.

UI applications like mobile apps always try to keep the view in sync with the state of the application. Example: Imagine driving a car. The speed reading on the dashboard is nothing but the state (speed) of the car. If the dashboard shows a wrong reading, then it’s an inconsistency.  

 UI = _f(AppState)_. 
 
 
 SwiftUI has an infrastructure wherein data is bound to the UI (data binding). In SwiftUI, showing an alert is controlled through binding. The performance impact of rerendering (invalidating) the view consequent to data change is handled by the framework. So using the data to drive the UI (data-driven UI) will wipe out the inconsistencies that exist between the data and the UI.




