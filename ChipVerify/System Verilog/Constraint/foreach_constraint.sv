class ABC;
    rand bit [3:0] array [5];

    // This constraint will iterate through each of the 5 elements
    // in an array and set each element to the value of its
    // particular index
    constraint c_array  {   
                            foreach (array[i]) {
                                array[i] == i;
                            }
                        }
endclass

module tb;
    initial begin
        ABC abc = new();
        abc.randomize();
        $display("array = %p", abc.array);
    end
endmodule
/* sim log :
array = '{'h0, 'h1, 'h2, 'h3, 'h4} */


// Dynamic Arrays/Queues
class ABC;
    rand bit [3:0] darray [];       // Dynamic array -> size unknown
    rand bit [3:0] queue [$];       // Queue -> size unknown

    // Assign size for the queue if not already known
    constraint c_qsize { queue.size() == 5; }

    // Constrain each element of both the arrays
    constraint c_array {
        foreach (darray[i])
            darray[i] == i;
        foreach (queue[i])
            queue[i] == i + 1;
    }

    // Size of an array can be assigned using a constraint like
    // we have done for the queue, but let's assign the size before
    // calling randomization
    function new ();
        darray = new[5];        // Assign size of dynamic array
    endfunction
endclass

module tb;
    initial begin
        ABC abc = new;
        abc.randomize();
        $display("array = %p \n queue = %p", abc.darray, abc.queue);
    end
endmodule

// Multidimensional Arrays
class ABC;
    rand bit [4:0] [3:0] md_array [2] [5];      // Multidimansional Arrays

    constraint c_md_array {
        foreach (md_array[i]) {
            foreach (md_array[i][j]) {
                foreach (md_array[i][j][k]) {
                    if (k % 2 == 0)
                        md_array[i][j][k] == 4'hF;
                    else
                        md_array[i][j][k] == 4'h0;
                }
            }
        }
    }
endclass

module tb;
    initial begin
        ABC abc = new;
        abc.randomize();
        $display("md_array = %p", abc.md_array);
    end
endmodule
/* sim log :
md_array = '{'{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}, '{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}} */



/* sim log :
md_array[0][0] -> 一個 5 × 4 的位元矩陣
md_array[0][1] -> 一個 5 × 4 的位元矩陣


md_array[x][y]:
| 4:0 | 4:0 | 4:0 | 4:0 |
| 4:0 | 4:0 | 4:0 | 4:0 |
| 4:0 | 4:0 | 4:0 | 4:0 |
| 4:0 | 4:0 | 4:0 | 4:0 |
| 4:0 | 4:0 | 4:0 | 4:0 |

*/


// Multidimensional Dynamic Arrays
class ABC;
    rand bit[3:0] md_array [][];    // Multidimansional Arrays with unknown size

    constraint c_md_array {
        // First assign the size of the first dimension of md_array
        md_array.size() == 2;

        // Then for each sub-array in the first dimension do the following:
        foreach (md_array[i]) {

            // Randomize size of the sub-array to a value within the range
            md_array[i].size() inside {[1:5]};

            // Iterate over the second dimension
            foreach (md_array[i][j]) {

                // Assign constraint for values to the second dimension
                md_array[i][j] inside {[1:10]};
            }
        }
    }
endclass

module tb;
    initial begin
        ABC abc = new;
        abc.randomize();
        $display("md_array = %p", abc.md_array);
    end
endmodule
/* sim log :
md_array = '{'{'h9, 'h6, 'h7, 'h9, 'h1}, '{'h5, 'h9, 'h4, 'h2}} */


// Array Reduction Iterative Constraint
class ABC;
    rand bit [3:0] array [5];

    // Intrepreted as int'(array[0]) + int'(array[1]) + ... + int'(array[4]) == 20;
    constraint c_sum {array.sum() with(int'(item)) == 20; }

    constraint c_prod {array.product() with(itme > 0) > 30; }

endclass

module tb;
    initial begin
        ABC abc = new;
        abc.randomize();
        $display ("array = %p", abc.array);
    end
endmodule

/* sim log :
array = '{'h4, 'h2, 'h2, 'h4, 'h8} */
