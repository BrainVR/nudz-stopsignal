## Task description

participant has to react with a left or right key to the left or right arrow displayed on the screen. Some trials give participant a stop signal and in these cases participants should NOT react to the arrow.

The timing of the stop signal is modulated by the software so that participants are kept at about 50 percent success rate

## data description
sstrial = trial with a stop signal
nstrial = no stop signal

values.stimulus = which arrow is displayed
values. correct = was the answer correct? - correct in both key and response 0 - error, 2 = correct
values.response = 0 no reaction, 1 = key 1 pressed, 2 = key 2 pressed
values.ssd = time of the stop signal

expressions values can be ignored atm

block 1 and 2 are the same but there is a pause between them

## Result description

Results are calculated for each block separately as well as for the entire set of all blocks (generally 3). The results are coded in the following way

{metric}_{stop/nostop}_[correct/error]_{block}

e.g. accuracy_

metrics can be:
- mean_rt: mean reaction time
- median_rt: meanmedian reaction time
- accuracy: ratio of correct answers (different for everything correct vs signal correct results, see below)

Trial type:

- stop: participant should NOT press the key
- nostop: participant should press the key

Trial correct:

Optional parameter. If missing (e.g. accuracy_stop_012) then it refers to both correct and incorrect trials.

There are two distinct ways of computing correct results - either in respect to the signal or in respect ot the stimulus as well. In Signal correct, participant is correct if they pressed any key or abstained from pressing it when signal is given. In the Everything correct, the participant also needs to press correct key in the "nostop" trials as well. Otherwise they are marked as wrong. 

The example of the distinction is the mean_rt_nostop_error - in "Signal correct" this is not valid, as there is no option to make a mistake in nostop trials as any key counts. In Everything correct this will be a mean reaction time in trials where participant pressed the wrong key.

potential combinations:
- stop_error = trials where participant pressed a key when they should not have. It does not matter which key they pressed. Same in Everything correct and Signal correct
- nostop_error = trials where participant pressed a wrong keypress. Correctly pressed a key, but the wrong one. In the "Signal correct" this will be effectively missing

- stop_correct = trials where participant correcly did not press any keys. Same in Everything correct and Signal correct
- nostop_correct = trials where participant pressed a correct key (Everything correct) or pressed any key in "Signal correct"

