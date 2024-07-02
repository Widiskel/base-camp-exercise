// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

error NotApproved(string albumName);

contract FavoriteRecords {

    struct Album {
        string name;
        bool status;
    }
    mapping(uint256 => Album) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;

    constructor() {
        approvedRecords[1] = Album("Thriller", true);
        approvedRecords[2] = Album("Back in Black", true);
        approvedRecords[3] = Album("The Bodyguard", true);
        approvedRecords[4] = Album("The Dark Side of the Moon", true);
        approvedRecords[5] = Album("Their Greatest Hits (1971-1975)", true);
        approvedRecords[6] = Album("Hotel California", true);
        approvedRecords[7] = Album("Come On Over", true);
        approvedRecords[8] = Album("Rumours", true);
        approvedRecords[9] = Album("Saturday Night Fever", true);
    }

    // retrieve all data ( approvedRecords )
    function getApprovedRecords() public view returns(string[] memory) {
        string[] memory allApprovedRecords = new string[](9);

        for (uint256 i = 1; i <= 9; i++) {
            allApprovedRecords[i - 1] = approvedRecords[i].name;
        }

        return allApprovedRecords;
    }

    // Helper function to get the albumId by name
    function getAlbumId(string memory albumName) internal view returns(uint256) {
        for (uint256 i = 1; i <= 9; i++) {
            if (keccak256(abi.encodePacked(approvedRecords[i].name)) == keccak256(abi.encodePacked(albumName))) {
                return i;
            }
        }
        revert NotApproved(albumName);
    }

    // Add Record to Favorites
    function addRecord(string memory albumName) public {
        uint256 albumId = getAlbumId(albumName);
        require(approvedRecords[albumId].status, string(abi.encodePacked(albumName, " is not approved")));
        
        userFavorites[msg.sender][albumName] = true;
    }

    // Users' Lists
    function getUserFavorites(address userAddress) public view returns(string[] memory) {
        string[] memory favorites = new string[](9);
        uint256 count = 0;

        for (uint256 i = 1; i <= 9; i++) {
            string memory albumName = approvedRecords[i].name;
            if (userFavorites[userAddress][albumName]) {
                favorites[count] = albumName;
                count++;
            }
        }

        // Create a new array with the correct length
        string[] memory result = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = favorites[i];
        }

        return result;
    }


    // Reset userFavorites for the sender
    function resetUserFavorites() public {
        for (uint256 i = 1; i <= 9; i++) {
            string memory albumName = approvedRecords[i].name;
            userFavorites[msg.sender][albumName] = false;
        }
    }

}