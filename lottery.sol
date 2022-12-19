// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract KBMLottery is Ownable {
    using Counters for Counters.Counter;

    address nftAddr;
    bool submittable;

    Counters.Counter private _roundCounter;
    mapping(uint256 => mapping(address=>uint256)) private _numbersPerRound;
    mapping(uint256 => address[]) private _submittersPerRound;

    constructor(address _nftAddr) {
        _changeNftAddr(_nftAddr);
        submittable = true;
    }

    event NumberSubmitted(address indexed submitter, uint256 indexed number);
    event NewRoundStarted(uint256 round);
    event RoundStopped(uint256 round);
    event NftAddrChanged(address nftAddr);

    modifier onlySubmittable() {
        require(submittable == true, "KBMLottery: not submittable");
        _;
    }

    modifier onlyNFTOwner() {
        address from = msg.sender;
        uint256 balance = IERC721(nftAddr).balanceOf(from);
        require(balance > 0, "KBMLottery: one or more NFTs are required to submit");
        _;
    }

    // internal functions
    function _changeNftAddr(address _nftAddr) internal {
        nftAddr = _nftAddr;
        emit NftAddrChanged(nftAddr);
    }

    // owner functions
    function changeNftAddr(address _nftAddr) public onlyOwner {
        _changeNftAddr(_nftAddr);
    }

    function startNewRound() public onlyOwner {
        _roundCounter.increment();
        submittable = true;
        emit NewRoundStarted(_roundCounter.current());
    }

    function stopRound() public onlyOwner {
        submittable = false;
        emit RoundStopped(_roundCounter.current());
    }

    // public functions
    function submitRandom(uint256 num) public onlySubmittable onlyNFTOwner {
        uint256 round = _roundCounter.current();
        address from = msg.sender;

        require(num > 0, "num should not be zero.");

        if(_numbersPerRound[round][from] == 0) {
            _submittersPerRound[round].push(from);
        }

        _numbersPerRound[round][from] = num;

        emit NumberSubmitted(from, num);
    }

    // view functions
    function calcRandom(uint256 round) public view returns (uint256) {
        uint256 random = 0;
        for(uint256 i = 0; i < _submittersPerRound[round].length; i++) {
            uint256 num = _numbersPerRound[round][_submittersPerRound[round][i]];
            random = uint256(keccak256(abi.encodePacked(random, uint256(keccak256(abi.encodePacked(num))))));
        }

        return random;
    }

    function getRound() public view returns (uint256) {
        return _roundCounter.current();
    }

    function getSubmitters(uint256 round) public view returns (address[] memory) {
        return _submittersPerRound[round];
    }

    function getNftAddr() public view returns (address) {
        return nftAddr;
    }

    function isSubmittable() public view returns (bool) {
        return submittable;
    }

}