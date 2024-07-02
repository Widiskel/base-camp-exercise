// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    mapping(uint => Contact) private contacts;
    uint private nextId;

    error ContactNotFound(uint id);

    constructor() Ownable(msg.sender) {}

    function addContact(string memory _firstName, string memory _lastName, uint[] memory _phoneNumbers) public onlyOwner {
        contacts[nextId] = Contact(nextId, _firstName, _lastName, _phoneNumbers);
        nextId++;
    }

    function deleteContact(uint _id) public onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        delete contacts[_id];
    }

    function getContact(uint _id) public view returns (string memory firstName, string memory lastName, uint[] memory phoneNumbers) {
        Contact storage contact = contacts[_id];
        if (contact.id == 0) {
            revert ContactNotFound(_id);
        }
        return (contact.firstName, contact.lastName, contact.phoneNumbers);
    }

    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](nextId);
        for (uint i = 0; i < nextId; i++) {
            allContacts[i] = contacts[i];
        }
        return allContacts;
    }
}

contract AddressBookFactory {
    function deploy() public returns (AddressBook) {
        AddressBook newAddressBook = new AddressBook();
        newAddressBook.transferOwnership(msg.sender);
        return newAddressBook;
    }
}