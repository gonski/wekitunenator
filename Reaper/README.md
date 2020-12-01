# Reaper configuration 
You may need to modify your audio device input/output configuration `Preferences>Audio>Device`.

## Install FXs
Download and install Graillon 2 Live Changer free edition [here](https://www.auburnsounds.com/products/Graillon.html), in order to have auto-tune.

## Buffer size
In order to obtain a good real-time performance you should modify the default buffer size in `REAPER>Preferences>Audio>Device`. Check the `Request block size` box and set it to 128. You may need a larger size if you hear clicks, it depends on your computer.
<div style="text-align:center"><img src="./.bin/buffer.png"/></div>

## Setting up OSC control 
* Go to `Preferences>Control/OSC/web`. Then click on the `Add` button.
<div style="text-align:center"><img src="./.bin/reaper_preferences.png"/></div>

* In the `Control Surface Settings`window, in the `Control surface mode` dropdown menu, select `OSC (Open Sound Control)`. In the `Pattern config` menu, select `Processing`. In `Mode`, select `Local port`. Then set `Local listen port` to `6449` and tick the option `Allow binding messages to REAPER actions and FX learn`. You won't need to modify the local IP. Your configuration should look like that (the local IP might look different):

<div style="text-align:center"><img src="./.bin/control_surface_settings.png"/></div>

Click on `Ok` and you're ready to go!
