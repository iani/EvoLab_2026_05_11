// The key to indian polyrhythmic art of korvai in talas
// Otherwise known in the west also as a type of hemiola
Tsk.play([\day, \night], [0.1, 0.2, 0.1], 16)
// 土 20 12 2025 02:05
// Understand by comparing:
Tsk.play([\day, \night], [0.1, 0.2], 16)
Tsk.play([\day, \night], [0.1], 16)
Tsk.play([\day, \night], [0.2], 16)
Tsk.play([\day, \night], [0.1, 0.1, 0.2], inf);
Tsk.play([\day, \night], [0.1, 0.1, 0.2] * 2, inf); // slower
//--------------------------------------------------
//Understanding the resulting pattern throug grouping
([0.1, 0.1, 0.2] ! 6).flat.clump(2) collect: _.sum
//: result:
[ 0.2, 0.3, 0.3, 0.2, 0.3, 0.3, 0.2, 0.3, 0.3 ]
// This pattern corresponds to the latin american Tresillo 