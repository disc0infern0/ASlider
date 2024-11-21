#  To Do

## Sparkly thumb trails
Leave a fun sparkly effect behind the thumb when it's dragged

## Dynamic Trackmarks
Change dynamic trackmarks so the bottom of each mark is aligned a fixed amount below the centre of the track.
The amount should be calculated as half a standard track mark, or half the smallest height - as calculated in the Layout 

## Range selection
take a range as the binding, with the range paramter being a range between two closed ranges.

## Breathe, Wiggle shape effects

########################################################################################################

# Doing

## Merge Radial and Linear views
Each view, track, tint, thuumb etc should be responsible for changing when the sliderStyle.style changes from .linear to .radial , and should use common code as far as possible.

## Style comments
Add comments for each style setting so that it appears in quick look/help

## Align Radial and Linear styling
Review each style setting so that, ideally, each setting has meaning for both radial and linear styles.

#########################################################################################################

# Done

## Create radial style 
Create seperate project for circular sliders

## Initial merge of radial style
Copy over the radial views and sliderStyle/sliderHelper settings, and get the radial style working

## Radial Thumb Bounce
Make the radial thumb bounce on drag start

## Radial Auto Sizing
The current auto track marks works well for smaller radii, but ends up putting too few trackmarks in a larger circle.
Refine algorithm for calculating how many track marks can fit to the inner radius of the track
Position correctly 

## Sort out sliderIndicator
should the options be [ .thumb, .tint, .trackMark(.regular) / .trackMark(.dynamic(percent: Double, growth: Double)] ?
or [ .thumb, .tint, .trackMark ]  and have a trackMarkStyle = .regular / .dynamic
Change dynamic trackmarks so the bottom of each mark is aligned a fixed amount below the centre of the track.
The amount should be calculated as half a standard track mark


## Track Values
To align the set slidervalue and get slidervalue functions for radial and linear sliders, calculate positions along the slider as a Double.
For a radial slider, a given slider value should be translated to a track value by calculating the radians of the angle. 
For a linear slider, a given slider value should be translated to a track value by scaling based on the track length..
