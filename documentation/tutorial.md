# Creating an App

Your first app is going to be very simple, but it will demonstrate some important concepts. We are going to make a simple tapping game to keep a balloon in the air. Each time the balloon is tapped, we will "push" it a little higher.

## Starting a Project

Creating a new project in Corona is easy. In just a few simple steps you'll be ready to make your first app.

1. Open the Corona Simulator.
2. Click New Project from the welcome window or select New Project... from the File menu.
3. For the project/application name, type BalloonTap and ensure that the Blank template option is selected. Leave the other settings at default and click OK (Windows) or Next (Mac). This will create the basic files for your first game in the location (folder) that you specified. This is also the folder in which you'll place all of your app files/assets, including images, program files, etc.

## Including Images

For this project, you will need three image files, placed within the pictures folder of the BalloonTap project folder created above. In this repository, you can find them in the BalloonTap folder.

## Loading the Background

The first image that we need to load is the background. Corona places everything on the screen from back to front in regards to layering, so the first image we load will exist behind other images that are loaded afterward. While there are ways to change the layering order of images and send them to the back or front of the display stack, we'll keep this project simple and load them in a logical order.

Using your chosen text editor, locate and open the main.lua file within your project folder. The main.lua file is the foundational "core program file" of every Corona project and you cannot create an app without it. This is the Lua file with which the application starts, every time you run the app.

In this main.lua file, type in the following command:


```lua
    local background = display.newImageRect( "pictures/background.png", 360, 570 )
```

There are a several aspects involved with this command. Let's break it down:

* The first word, local, is a Lua command indicating that the next word will be a variable.
* ```display.newImageRect()``` is one of the Corona APIs. There are a couple of ways to load an image into your app, but ``` display.newImageRect()``` is special in that it can resize/scale the image.

The final step for the background is to position it at the correct location on the screen. Immediately following the line you just entered, add the two following commands:

```lua
    background.x = display.contentCenterX
    background.y = display.contentCenterY
```

By default, Corona will position the center of an object at the coordinate point of 0,0 which is located in the upper-left corner of the screen. By changing the object's x and y properties, however, we can move the background image to a new location.
For this project, we'll place the background in the center of the screen.

## Loading the Platform

Time to load the platform. This is very similar to loading the background. Following the three lines of code you've already typed, enter the following commands:

```lua
    local platform = display.newImageRect( "pictures/platform.png", 300, 50 )
    platform.x = display.contentCenterX
    platform.y = display.contentHeight-25
```
As you probably noticed, there is one minor change compared to the background: instead of positioning the platform in the vertical center, we want it near the bottom of the screen. By using the command ```display.contentHeight```, we know the height of the content area. But remember that platform.y places the center of the object at the specified location. So, because the height of this object is 50 pixels, we subtract 25 pixels from the value, ensuring that the entire platform can be seen on screen.

## Loading the Balloon

To load the balloon, we'll follow the same process. Below the previous commands, type these lines:

```lua
    local balloon = display.newImageRect( "pictures/balloon.png", 112, 112 )
    balloon.x = display.contentCenterX
    balloon.y = display.contentCenterY
```

In addition, to give the balloon a slightly transparent appearance, we'll reduce the object's opacity (alpha) slightly. On the next line, set the balloon's alpha property to 80% (0.8):

```lua
    balloon.alpha = 0.8
```

## Adding Physics

Time to get into physics! Corona includes the Box2D physics engine for your use in building apps. While using physics is not required to make a game, it makes it much easier to handle many game situations.

Including physics is very easy with Corona. Below the previous lines, add these commands:

```lua
    local physics = require( "physics" )
    physics.start()
```

Let's explain these two lines in a little more detail:

* The command ```local physics = require( "physics" )``` loads the Box2D physics engine into your app and associates it with the local variable ```physics``` for later reference. This gives you the ability to call other commands within the physics library using the physics namespace variable, as you'll see in a moment.

* ```physics.start()``` does exactly what you might guess — it starts the physics engine.

If you save and relaunch you won't see any difference in your game... yet. That is because we haven't given the physics engine anything to do. For physics to work, we need to convert the images/objects that were created into physical objects. This is done with the command ```physics.addBody```:

```lua
    physics.addBody( platform, "static" )
```

This tells the physics engine to add a physical "body" to the image that is stored in platform. 
In addition, the second parameter tells Corona to treat it as a static physical object. 
What does this mean? 
Basically, static physical objects are not affected by gravity or other physical forces, so anytime you have an object which shouldn't move, set its type to "static".

Now add a physical body to the balloon:

```lua
    physics.addBody( balloon, "dynamic", { radius=50, bounce=0.3 } )
```

The final part of this ```physics.addBody``` command is used to adjust the balloon's body properties — in this case we'll give it a round shape and adjust its bounce/restitution value. 
Parameters must be placed in curly brackets ({}) (referred to as a table in the Lua programming language).

* Because the balloon is a round object, we assign it a radius property with a value of 50. This value basically matches the size of our balloon image, but you may need to adjust it slightly if you created your own balloon image.

* The bounce value can be any non-negative decimal or integer value. A value of 0 means that the balloon has no bounce, while a value of 1 will make it bounce back with 100% of its collision energy. A value of 0.3, as seen above, will make it bounce back with 30% of its energy.

## Functions

At this point, we have a balloon that drops onto a platform and bounces slightly. 
That's not very fun, so let's make this into a game.
For our balloon tap game to work, we need to be able to push the balloon up a little each time it's tapped.

To perform this kind of feature, functions are used.

Let's create our first function:

```lua
    local function pushBalloon()
 
    end
```

However, it's currently an empty function so it won't actually do anything if we run it. 
Let's fix that by adding the following line of code inside the function:

```lua
    balloon:applyLinearImpulse( 0, -0.75, balloon.x, balloon.y )
```

```balloon:applyLinearImpulse``` is a really cool command. 
When applied to a dynamic physical object like the balloon, it applies a "push" to the object in any direction.
The parameters that we pass tell the physics engine how much force to apply (both horizontally and vertically) and also where on the object's body to apply the force.

The first two parameters, 0 and -0.75, indicate the amount of directional force. 
The first number is the horizontal, or x direction, and the second number is the vertical, or y direction. 
Since we only want to push the balloon upwards (not left or right), we use 0 as the first parameter. 
For the second parameter, with a value of -0.75, we tell the physics engine to push the balloon up a little bit. 
The value of this number determines the amount of force that is applied: the bigger the number, the higher the force.

The third and fourth parameters, ```balloon.x``` and ```balloon.y```, tell the physics engine where to apply the force, relative to the balloon itself. 
If you apply the force at a location which is not the center of the balloon, it may cause the balloon to move in an unexpected direction or spin around. 
For this game, we will keep the force focused on the center of the balloon.

## Events

Events are what create interactivity and, in many ways, Corona is an event-based framework where information is dispatched during a specific event to an event listener. 
Whether that event is the user touching an object/button, tapping the screen, or (in this game) tapping the balloon, Corona can react by triggering an event.

Adding an event listener is easy — do so now, following the function:

```lua
    balloon:addEventListener( "tap", pushBalloon )
```

Let's inspect the structure of this new command:

* First, we must tell Corona which object is involved in the event listener. 
For this game, we want to detect an event related directly to the balloon object.

* Immediately following this, add ```addEventListener```. 
In Lua, this is called an object method. 
Essentially, addEventListener, following the colon, tells Corona that we want to add an event listener to balloon, specified before the colon.

* Inside the parentheses are two parameters which complete the command. 
The first parameter is the event type which Corona will listen for, in this case "tap". 
The second parameter is the function which should be run (called) when the event occurs, in this case the ```pushBalloon()``` function which we wrote in the previous section. 
Essentially, we're telling Corona to run the ```pushBalloon()``` function every time the user taps the balloon.

## Extra Credit

Congratulations, you have created a basic game in just 30 lines of code.
But there is something missing, isn't there? 
Wouldn't it be nice if the game kept track of how many times the balloon was tapped? Fortunately that's easy to add.

First, let's create a local Lua variable to keep track of the tap count. 
You can add this at the very top of your existing code. 
In this case, we'll use it to store an integer instead of associating it with an image. 
Since the player should begin the game with no score, we'll initially set its value to 0.

```lua
    local tapCount = 0
```

Next, let's create a visual object to display the number of taps on the balloon. 
Remember the rules of layering discussed earlier in this chapter? 
New objects will be placed in front of other objects which were loaded previously, so this object should be loaded after you load the background (otherwise it will be placed behind the background and you won't see it).

After the three lines which load/position the background, add the following command:

```lua
    local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
```

Let's inspect this command in more detail:

* ```display.newText()``` is another Corona API, but instead of loading an image as we did earlier, this command creates a text object. 
Because we are assigning the variable tapText to this object, we'll be able to make changes to the text during our game, such as changing the printed number to match how many times the balloon was tapped.

*  The first parameter in the parentheses is the initial printed value for the text.
The second two parameters, ```display.contentCenterX``` and 20, are used to position this text object on the screen. 
You'll notice that we use the same shortcut of display.contentCenterX to position the object in the horizontal center of the screen, and 20 to set its vertical y position near the top of the screen.
The fourth parameter for this API is the font in which to render the text. 
Corona supports custom fonts across all platforms, but for this game we'll use the default system font by specifying native.systemFont.
The final parameter (40) is the intended size of the rendered text.

By default, text created with ```display.newText()``` will be white. 
Fortunately, it's easy to change this. Directly following the line you just added, type the following command:

```lua
    tapText:setFillColor( 0, 0, 0 )
```

Simply put, this ```setFillColor()``` command modifies the fill color of the object tapText.

The new text object looks nice, but it doesn't actually do anything. 
To make it update when the player taps the balloon, we'll need to modify our ```pushBalloon()``` function. 
Inside this function, following the ```balloon:applyLinearImpulse()``` command, insert the two following lines:

```lua
    tapCount = tapCount + 1
    tapText.text = tapCount
```

Let's examine these lines individually:

* The ```tapCount = tapCount + 1``` command increases the tapCount variable by 1 each time the balloon is tapped.

* The second new command, ```tapText.text = tapCount```, updates the text property of our tapText object. 
This allows us to quickly change text without having to create a new object each time.

Copyright © by Corona
