//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Lottery {

    //Variables de estdo.
    uint public minFee;
    address owner;
    address[] players;
    mapping (address => uint ) public playerBalances;

    constructor(uint _minFee) {
        minFee = _minFee;
        owner = msg.sender;
    }

    function play() public payable minFeePay {

        players.push(msg.sender);
        playerBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRadomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public {
        uint index = getRadomNumber() % players.length;
        (bool sucess, ) = players[index].call{value:getBalance()}("");
        require(sucess, "Paga fallo, por favor reintente");
        players = new address[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier minFeePay() {
        require(msg.value >= minFee, "Por favor pagar mas");
        _;
    }
}
