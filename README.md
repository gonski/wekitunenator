# wekitunenator
Authors: Gonzalo Nieto [@GoniGit](https://github.com/GoniGit) and Teresa Pelinski [@pelinski](https://github.com/pelinski).
Wekitunenator 3000 is our final project for the Advanced Interface Design master module at Universitat Pompeu Fabra. In this project...., we built an instrument 
* modifies voice by appliying some FXs
* it is controlled with fingers and hand positions and gestures. 
* FXs spaces (Fiebrink paper)
* go beyond a control paradigm and use ML as an exploratory tool

[project description + reference paper]

(video link)


## Setup
[simplified pipeline]
### Hand Tracking: HandPose-OSC
For the hand tracking we are using [handPoseOSC](https://github.com/faaip/HandPose-OSC) by [@faiip](https://github.com/faaip/). You will need to have [nodejs](https://nodejs.org/en/) installed. First clone the repo. Then, go to the cloned repo directory `cd HandPose-Osc.git` and install the project dependencies using yarn `yarn install`. Once you've done that you can run the app with the command `yarn start`. 

### Processing
[have an executable?]

### Wekinator
input port:8000
27 inputs

### Reaper configuration 
You can install Reaper [here](https://www.reaper.fm/). The configuration instructions can be found [here](./Reaper/README.md). 