// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Employee abstract contract
abstract contract Employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint);
}

// Salaried contract
contract Salaried is Employee {
    uint public annualSalary;

    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

// Hourly contract
contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view override returns (uint) {
        // 2080 hours in a year
        return hourlyRate * 2080;
    }
}

// Manager contract
contract Manager {
    uint[] public employeeIds;

    function addReport(uint _employeeId) public {
        employeeIds.push(_employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }
}

// Salesperson contract inheriting Hourly
contract Salesperson is Hourly {
    constructor() Hourly(55555, 12345, 20) {}
}

// Engineering Manager contract inheriting Salaried and Manager
contract EngineeringManager is Salaried, Manager {
    constructor() Salaried(54321, 11111, 200000) Manager() {}
}

// InheritanceSubmission contract
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}