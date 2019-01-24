# Notes for first topic

I began the course by discussing with Dr. Mayfield about what I would like to learn about. We discussed the crossover of video games and mobile application development, two topics I’m highly interested in. We settled on a class covering the topic of augmented reality. 

By following the tutorial on [freeCodeCamp's Medium](https://medium.freecodecamp.org/how-to-get-started-with-ar-in-swift-the-easy-way-7399fe1c82f5) I was able to take the first steps into this topic. 

The first step was to enable camera permissions. Due to the nature of augmented reality, this is needed for all AR applications. 

After that, I had to import ARKit and get an instance of the configuration which I provided to the sceneview outlet when it is run. I enabled the view of feature points and the world origin and ran the application on my phone which gave me this nice first experience in developing AR. 
(see below image of computer/origin/feature points)


![Feature points/ Origin](https://i.stack.imgur.com/7e46f.jpg)

After this, the tutorial mentioned I should create a SCNode and attach a capsule to it. To better understand what I was doing, I read the documentation about `SCNode` on [Apple’s SceneKit developer notes] (https://developer.apple.com/documentation/scenekit/scnnode?changes=_8).   

The `SCNode` acts as an anchor of sorts, for you to build the scene out of. It’s simply a transform in 3D space, representing the position, orientation, and scale all in relation to its parent node or  the origin. Then, when you create a 3D object that you want to represent in the world, you can attach it to this transform.

I was interested in what the values represented when I’m providing values to the transform and I found it on the [Apple developer site](https://developer.apple.com/documentation/scenekit/scnphysicsbody).

> All values in SceneKit’s physics simulation use the International System of Units (SI): The unit of mass is the kilogram; the units of force, impulse, and torque are the newton, newton-second, and newton-meter; and the unit of distance for node positions and sizes is the meter. Note that you need not attempt to provide realistic values for physical quantities—use whatever values produce the behavior or gameplay you’re looking for.

So, the unit of measurement is the meter. However, they basically say that it’s more important to just consider them as units and focus on making the behavior work as intended than to provide realistic numbers.

The next step was to make the view controller a delegate of the scene view and implement some variations of the renderer method. This is the lifecycle method that is called when nodes are updated, removed, added, etc.. to the scene. In the tutorial, they wrote an extension to the `ViewController` class, making the ViewController class always be a `ARSCNViewDelegate`. I don't like this approach as it applies to all ViewControllers, so I did not follow this tidbit. 

In this tutorial, we used the `didAdd`, `didUpdate`, and `didRemove` versions of this method. In `didAdd` we create the floor node using the new anchor that the method is provided. In the `didUpdate`, we do the same thing, but only after removing the old one. In `didRemove`, we simply remove the old node(s). 

Anchor information is combined and updated as ARKit gets a better understanding of the world. When it finds a new anchor point, it adds a new node there. However, later it may determine that the new anchor point it found was actually the same object it previously added an anchor to. In this case, it updates the geometry of the original anchor to include the new one, and deletes the new anchor. This cycle is what triggers the lifecycle methods to be called. 

By using these anchors and moving the camera around the screen, we can place a pattern on the floor. The tutorial starts out with a simple `UIColor.blue` pattern to demonstrate, but then we change it to an image. I used a Image Literal of lava in this case. 

