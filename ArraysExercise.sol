// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract ArraysExercise {
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    address[] public senders;
    uint[] public timestamps;

    // Return the entire numbers array
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    // Reset the numbers array to its initial value
    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    // Append an array to the existing numbers array
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Save the sender's address and timestamp
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Return timestamps and senders after January 1, 2000, 12:00am
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint y2kTimestamp = 946702800;
        uint[] memory recentTimestamps;
        address[] memory recentSenders;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                recentTimestamps = appendToArray(recentTimestamps, timestamps[i]);
                recentSenders = appendToArray(recentSenders, senders[i]);
            }
        }

        return (recentTimestamps, recentSenders);
    }

    // Reset senders array
    function resetSenders() public {
        delete senders;
    }

    // Reset timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }

    // Helper function to append to an array
    function appendToArray(uint[] memory array, uint element) internal pure returns (uint[] memory) {
        uint[] memory newArray = new uint[](array.length + 1);
        for (uint i = 0; i < array.length; i++) {
            newArray[i] = array[i];
        }
        newArray[array.length] = element;
        return newArray;
    }

    // Helper function to append to an array
    function appendToArray(address[] memory array, address element) internal pure returns (address[] memory) {
        address[] memory newArray = new address[](array.length + 1);
        for (uint i = 0; i < array.length; i++) {
            newArray[i] = array[i];
        }
        newArray[array.length] = element;
        return newArray;
    }
}