# Lodgify Mobile oversimplified calendar

This Flutter project contains a simple calendar application that displays the current month and year and allows users to switch between months.

## Assumptions

I assume, that **calendar_widget** is used only on **calendar_screen**. But still it can easily be extracted (along with bloc), to be reused as a separate component.



### Design decisions and rationale

Initial code was a little bit too complicated both on ui and on logic side. 

 - I think that using a Grid for the UI is a simpler solution than nested rows and columns. Also, the initial solution had a fixed width, which is not suitable for different screen sizes.
 - On the logic side, a simple list works better in terms of testability and overall logic simplicity.

 - For a state management solution I've chosen BLoC + Freezed. It's definitely an overkill for such a small app, but despite relatively big amount of boilerplate code it provides rigid structure which I like. Also it goes with good **bock_test** package which is nice too.

 - Instead if Blocs I've used Cubits. Blocs add some unnecessary event complications, and even heavier on boilerplate.

 - For **calendar_cubit**, I've decided to keep **calculateCalendarData()** inside the cubit. It could be moved to separate class, but the cubit was super empty, so I've left it there.

 - Also added some basic error logging with empty **analytics_service**, DataDog or some other analytics solutions could be added there.

#### Challenges you faced and how you solved them

I've encountered a DST-related issue, 26 of October was duplicated => October had 32 days. I've caught it with the help of **'should handle all 12 months correctly (non-leap year)'** test.

Solution was to move all date related calculations to UTC, except for isToday.

Also I've added some extra TZ test, to be sure nothing is broken.
