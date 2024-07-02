// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        results[0] = abs(int(_a) - int(_b));
        results[1] = abs(int(_b) - int(_c));
        results[2] = abs(int(_c) - int(_d));

        return results;
    }
    
    function abs(int x) internal pure returns (uint) {
        return uint(x > 0 ? x : -x);
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        int result = int(_base) + _modifier;
        require(result >= 1000 || _modifier < 0, "Result must be greater than or equal to 1000");
        return uint(result);
    }


    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    function popWithReturn() public returns (uint) {
        require(arr.length > 0, "Array is empty");
        uint index = arr.length - 1;
        uint value = arr[index];
        arr.pop();
        return value;
    }

    // The utility functions below are working as expected
    uint[] arr;

    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}