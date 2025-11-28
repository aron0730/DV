//* Scenario1: Creating object of Class 
//*            -> Method that do this should not consume time to make sure all the objects are ready at 0 nSec
//*
//* Scenario2: Applying stimulus to DUT on valid clock edge 
//*            -> Method that do this should consume time else we will apply 
//*               all the stimulus at 0nsec and get unexpected behavior

//* Phases : 1. Consume time : task -> need to be override, so without calling super
//*          2. Do not consume time: function with calling super