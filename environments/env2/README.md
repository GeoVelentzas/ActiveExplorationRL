## env2: An environment for BabyRobot simulation

- There are 4 positions on a table p1, p2, p3, p4 and 3 cubes c1, c2, c3 arbitrariliy placed on those positions. Cubes that are on the same position are placed one over the other. Position p2 is regarded as the center position.

- An initial state like (12, 3, x, x) inticates that cubes c1 and c2 are placed at p1 with c2 over c1, while cube c3 is placed p2. Positions p3 and p4 are empty (indicated by x).

- Action a1 takes the top cube from position p1 (if there is any) and places at position p2 (or on the top of the existing cube if there is any). We denote this as a1:p1->p2.

- There are 6 actions, a1:p1->p2, a2:p3->p2, a3:p4->p2, a4:p2->p1, a5:p2->p3, a6:p2->p4, therefore when action a3 is performed from state (1,2,x,3) results in state transition (1,23,x,x).