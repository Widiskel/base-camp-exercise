// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        unchecked {
            sum = _a + _b;
            error = sum < _a || sum < _b;
        }
    }

    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        unchecked {
            if (_b > _a) {
                error = true;
                difference = 0;
            } else {
                difference = _a - _b;
            }
        }
    }
}