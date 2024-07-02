// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

contract EmployeeStorage{
    
    uint64 public idNumber;
    string public name;
    uint32 private salary;
    uint16 private shares;

    constructor(uint16 _shares, string memory _name, uint32 _salary, uint64 _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    function viewSalary() external view  returns (uint32) {
        return salary;
    }

    function viewShares() external view returns (uint16) {
        return shares;
    }

    error TooManyShares(uint16 totalShares);

    function grantShares(uint16 _newShares) external {
        require(_newShares <= 5000, "Too many shares");

        uint16 totalShares = shares + _newShares;

        if (totalShares > 5000) {
            revert TooManyShares(totalShares);
        }

        shares = totalShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by you wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }

}