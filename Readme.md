# **NewSlider**
================

A new slider ... 

... remarkably similar to the old, classic Apple one. Yes, really.


In fact it is so similar, that if you change all occurrences of Slider to NewSlider, you can barely tell the difference. ( except for the inconvenience of having to import this package and add an import statement to your code). 

<details>
<summary>Preface</summary>

I said earlier that after changing your code you could *barely* tell the difference. Well of course, there are some differences, otherwise what would be the point?  One of those is that When you click on the thumb, it will just bounce slightly to let you know that you have it's attention. It is a subtle effect, but is remarkably pleasing. [Little things are important]. Also, when you drag the thumb symbol, it will, by default, turn transparent so that you can see the track and trackmarks underneath. 

Having to add a package to your code and import a library whenever you want to use this spiffy new slider is, as heretofore mentioned, an undoubted pain. On the plus side however, and this, I suspect, is the reason you are still reading this, is a whole slew of customisation options.  
Side note: NewSlider is fully Swift 6 compatible, and passess all compiler concurrency checks.
</details>

## **NewSlider vs Slider**

- **Bound Ints**     
The slider value can now be a bound Int! Huzzah! This was in fact the original reason for this package. [Scope creep is real] [ and yes, I know you can create a computed variable of an int that produces a Bound<Double> for the slider, but ... that code is ugly]
- **Symbols**   
You can replace the thumb shape altogether with a symbol of your choice. 
( If you always wanted a Thor style lighning indicator on your slider, it now comes preconfigured, just select `thumbSymbol = .bolt` in your styling closure )
- **Colors**   
Change the track color, the tint color, the thumb color, the trackmarks color.
The trackmark color can be specififed with an array of colors, which will then be presented as a linear gradient, which is particularly nice when using dynamically sized trackmarks. (see below)
- **Sizes**   
All elements of the slider can be altered, the track height, the track marks width and height, the thumb width and height (The thumb can even be removed - see below )
- **Slider indicators**  
You have 3 options to indicate the slider value on the ..er.. slider. You can specify any, or none of: trackmarks, thumb symbol, or tint bar.

- **Dynamic trackmarks**     
Dynamic trackmarks grow and fall in size as you drag across the slider.
- **Thumb/Symbol animations**
- **Track Labels**   
Easily display slider values underneath the slider.
- **Accessibility labels and actions**
- **Keyboard control**, with feedback at each end
- **Confgurable tint bar**
See below for more details
- **Preconfigured, tweakable, themes**


## **How?**
You might reasonably expect that for a control with so many features, it must be terribly tedious to use.
<details>
<summary> Editors note 1</summary>
There is probably a square law of proportionalilty that dicates that explains why any increase in scope must have an exponentially higher cost of use, and that any hope for an alternative is just a pipe dream.
</details>
<details>
<summary> Editors note 2</summary>
After googling 'law of proportionality', Article 5(4) of the Treaty on European Union absolutely drives this point home like a sperm whale would if it fell on you from 10,000 feet. I am not going to attempt an explanation of Article 5(4), but if I did, it would hurt. Alot. I leave it you, dear reader, to determine if that law can be broken.   
</details>
Here the customisation is done via a style environment modifier, similarly to how Apple does it for other controls. You are free to create your own styles, via the SliderStyle.init() method, or simply invoke a predefined style, or modify one that, [Blue Peter style](https://www.youtube.com/watch?v=ziqD1xvSpF4), already exists.
Specifically, you confgure a SliderStyle struct via a new view modifier; sliderStyle.
*e.g.*
```swift
struct YourView: View {
   var body: some View { 
	Settings()
	.sliderStyle(.classic)
   }
}
```
Any NewSlider's called within the Settings view, along with any view descendants will use the .classic preconfigured theme. (As an aside, this .classic is configured to be as identical to the regular Slider as possible )
If you use the newClassic theme;- 
```.sliderStyle(.newClassic)```
, then you get the updated verions that goes transparent, and bounces a little on selection.


### **Themes**
As at time of writing, there are just 3 preconfigured themes; `.classic, .newClassic, .orangey`. Others way be added, and you can add your own by writing an extension of SliderStyle. As is the usual way of things, the init method will require all the settings to be passed in the right order, so in preference, I would recommend modifying an existing theme through a closure configuration method.
e.g.
```swift
struct YourView: View {
   var body: some View { 
	Settings()
	.sliderStyle(.classic) { style in 
        style.thumbWidth = 30
        style.trackMarks = .every(2) //  Use .auto for the automatic setting of 20 equally spaced trackmarks
    }
   }
}
```
Using the above closure method for modifying a theme gives you the benefit of filling in style settings in any order you like, and as an added bonus code completion will help you discover settings. Most track related settings start with `track`, thumb settings with `thumb` and 

# Appendix

I still remain hopeful that Apple will update the classic SwiftUI Slider to be a little more stylable, as they have done with other controls, but for now, this might suffice.

