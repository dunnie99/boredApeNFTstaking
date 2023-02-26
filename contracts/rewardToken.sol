// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CSRtoken is ERC20 {
 
    address owner;
    string _name;
    string _symbol;

    constructor(string memory name, string memory symbol) ERC20(name, symbol){
        _name = name;
        _symbol = symbol;
        owner = msg.sender;
        mint();

        
//3 000 000 000 000 000 000
    }



    function mint() public {
        require(msg.sender == owner, "Not owner");
        _mint(msg.sender, 99 * 10**decimals());
    }


    function buyTOKEN(uint token) payable public {
    uint price = 5;
    require(msg.sender != address(0), "Zero Address!");
     
    require( msg.value >= price * token , "Insufficient balance!!!");
   
     _transfer(owner, msg.sender, token * 1e18);

    
    }
}
