#  SwiftUI Layout Inspector

Ole Begemann, 2022-09

Based on: [objc.io, Swift Talk episode 318, Inspecting SwiftUI's Layout Process (2022-08)](https://talk.objc.io/episodes/S01E318-inspecting-swiftui-s-layout-process)

Inspect the layout algorithm of SwiftUI views, i.e. what sizes views propose to
their children and what sizes they return to their parents.

![Layout Inspector screenshot on iPhone simulator](assets/LayoutInspector-screenshot.png)

## Requirements

iOS 16.0 or macOS 13.0 (requires the `Layout` protocol).

## Instructions

1.  Edit the `subject: some View` property in `ContentView`. It should contain
    the view tree you want to inspect.
    
2.  Add `.debugLayout()` at each point in the view tree where you want to inspect
    the layout algorithm (what sizes are being proposed and returned). 
        
    Example of a `subject` property with a few inspection points:
   
    ```swift
    var subject: some View {
        Text("Hello world")
            .debugLayout("Text")
            .padding(10)
            .debugLayout("padding")
            .background {
                Color.yellow
                    .debugLayout("yellow")
            }
            .debugLayout("background")
    }
    ```

4.  Build and run the app.

    - The subject view is displayed on top.
    - The table on the bottom displays the sizes that are being proposed at each
      inspection point in the subject view ("Proposal", and the resulting view 
      sizes ("Response").
    - You can tap/click items in the grid to highlight the respective view.
    - You can use the sliders to modify the size proposed to the subject view.
    - Some views cache certain layout information. Press "Reset layout cache"
      after modifying the sliders to reset the caches.