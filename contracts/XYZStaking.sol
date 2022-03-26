//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin-solidity/contracts/math/SafeMath.sol";

contract XYZStaking is ERC20, Ownable {
   using SafeMath for uint256;

   struct staker {
      address owner;
      uint256 initialTimestamp;
      bool timestampSet;
      uint256 timePeriod;
      uint256 contractBal;
   }

   mapping(uint => staker ) public stakeToken;
   uint stakeBalance = 0;

   constructor(address _owner, uint256 _supply)
}
