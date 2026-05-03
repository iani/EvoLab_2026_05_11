
# Objective / Definition
A way to build patterns incrementally or additively in time. This means,

	Given a pattern p1 and a pattern p2,
	play p1 first and then start p2. In this way you can build a series
	of patterns played one after the other.

# Problem: 
If one writes 
	[\p1, \p2],
Then p2 will start a given duration after p. 
One has to specify that duration in the duration argument of the call to play method.
Therefore, what is sought here is a way to make sure that \p2 will start after 
the end of \p1.


## Approach 1: Code the call to \p2 at the end of the previous pattern

Simple. 

## Approach 2: Pre-Calculate the duration of each pattern in a series

More complicated. 
# Solution

In both approaches above, the solution hinges upon knowing the duration \d of the action/segment just started, in order to schedule the next action/segment to start \d seconds in the future. So we can schedule the next beat if we obtain the time from the method call of the current/most recent beat.  This means **that we must use method calls directly to obtain the duration as return value**.  So we cannot use the controller mechanism.

