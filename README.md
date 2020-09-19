# Do-It-Baby

An intentionally designed todo app that uses Realm to store and retrieve data.

## Technologies Used

* Swift 5
* Xcode 11
* Realm
* CocoaPods


## Interface

![.](do-it-baby/create_lists.gif)

Upon opening the app, users can create lists for their todo items by tapping the '+' in the upper right hand corner of the screen and then following the prompts in the pop up.

![](create_todos.gif)

After creating a new list, tapping the list will bring the user to a new screen titled after the selected list, where they can create their todo items.

Each todo item after the first will be a degree darker than the one before it, making for a gradient-like aesthetic experience.

![](check_and_delete.gif)

Once a todo item has been created, tapping the todo will add a checkmark to indicate completion. If for some reason the todo needs to be unchecked, tapping on it again will remove the checkmark. Swiping an item from the right of the screen to the left, without swiping all the way accross, will present the user with the option to delete their todo by tapping the trash icon. Swiping from the right to the left all the way accross the screen will also delete the todo.

