//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract XYZStaking is ERC20 {
    using SafeMath for uint256;

    
    address[] internal stakeholders;

    // stakes for each stakeholder.
     
    mapping(address => uint256) internal stakes;

    // accumulated rewards for each stakeholder.
     
    mapping(address => uint256) internal rewards;

    // constructor for the Staking Token.
    // _owner The address to receive all tokens on constr
    // _supply The amount of tokens to mint on construction.
    constructor(address _owner, uint256 _supply) { 
        _mint(_owner, _supply);
    }

    // A method for a stakeholder stake.
     // _stake The size of the stake to be created.
     
    function createStake(uint256 _stake) public{
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }

    // A method for a stakeholder to remove a stake.
     //_stake The size of the stake to be removed.
     
    function removeStake(uint256 _stake) public {
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    // stake of specific stakeholder 
    function stakeOf(address _stakeholder) public view returns(uint256) {
        return stakes[_stakeholder];
    }


   //   calculate total stakes from all stakeholders.
     
    function totalStakes() public view returns(uint256) {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
        }
        return _totalStakes;
    }

    // ---------- STAKEHOLDERS ----------

   // The address to verify of stakeholder
    
    function isStakeholder(address _address) public view returns(bool, uint256) {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    // add new stakeholder
     
    function addStakeholder(address _stakeholder) public {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

  // remove a stakeholder.
     
    function removeStakeholder(address _stakeholder) public {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        } 
    }
    
    // check reward of stakeholder rewards
     
    function rewardOf(address _stakeholder) public view returns(uint256) {
        return rewards[_stakeholder];
    }

    // A method to the aggregated rewards from all stakeholders.
   
    function totalRewards() public view returns(uint256) {
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
        }
        return _totalRewards;
    }

    // The stakeholder to calculate rewards for.
    function calculateReward(address _stakeholder) public view returns(uint256) {
        return stakes[_stakeholder] / 100;
    }

    function withdrawReward() public {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
}
