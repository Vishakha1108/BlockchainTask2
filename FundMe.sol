// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


contract FundMe {
 

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {

        addressToAmountFunded[msg.sender] += msg.value;
        for(uint i = 0; i< funders.length; i++ ){
                if(funders[i] == msg.sender){
                return ;
            }
        }
        funders.push(msg.sender);
    }
    function withdraw() onlyOwner public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function transferOwnership(address newOwner) onlyOwner public {
       owner = newOwner;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }
    // receive() external payable {
    //     fund();
    // }
    // fallback() external payable {
    //     fund();
    // }
}
