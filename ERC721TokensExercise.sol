// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721{
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    mapping(address => uint256) public recipientHaikus;
    uint256 public counter;

    mapping(string => bool) private lineUsed;
    error HaikuNotUnique();
    error NotYourHaiku(uint256 _haikuId);
    error NoHaikusShared();

    constructor() ERC721("Haiku", "HK") { counter = 1; }

    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external  {
        if(lineUsed[_line1] || lineUsed[_line2] || lineUsed[_line3]){
            revert HaikuNotUnique();
        }

        lineUsed[_line1] = true;
        lineUsed[_line2] = true;
        lineUsed[_line3] = true;

        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        _safeMint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(address _to, uint256 _haikuId) public {
        if(ownerOf(_haikuId) != msg.sender){
            revert NotYourHaiku(_haikuId);
        }

        sharedHaikus[msg.sender].push(_haikuId);
        recipientHaikus[_to] = _haikuId;
    }

    function getMySharedHaikus() public view returns (uint256[] memory) {
        uint256[] memory authorSharedHaikus = sharedHaikus[msg.sender];
        if (authorSharedHaikus.length == 0) {
            revert NoHaikusShared();
        }
        return authorSharedHaikus;
    }
}