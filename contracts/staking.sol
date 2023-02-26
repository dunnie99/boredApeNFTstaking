// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract gatedStaking {
    IERC20 public rewardToken;
    IERC20 public stakeToken;
    IERC721 internal boredApeContract;
    address public admin;

    uint256 constant SECONDS_PER_YEAR = 31536000;

    struct User {
        uint256 stakedAmount;
        uint256 startTime;
        uint256 reward;
    }

    mapping(address => User) user;
    error tryAgain();

    constructor() {
        boredApeContract = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
        stakeToken = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        admin = msg.sender;
    }


    

    modifier onlyOwner() {
        require(msg.sender == admin, "NOT ADMIN");
        _;
    }

    function stake(uint256 amount) external {

        uint256 Apebalance = boredApeContract.balanceOf(msg.sender);
        require(Apebalance > 0, "NOT BOREDAPE HOLDER!");

        User storage _user = user[msg.sender];
        uint256 _amount = _user.stakedAmount;

        stakeToken.transferFrom(msg.sender, address(this), amount);

        if (_amount == 0) {
            _user.stakedAmount = amount;
            _user.startTime = block.timestamp;
        } else {
            updateReward();
            _user.stakedAmount += amount;
        }
    }

    function calcReward() public view returns (uint256 _reward) {
        User storage _user = user[msg.sender];

        uint256 _amount = _user.stakedAmount;
        uint256 _startTime = _user.startTime;
        uint256 duration = block.timestamp - _startTime;

        _reward = (duration * 50 * _amount) / (SECONDS_PER_YEAR * 100);
    }

    function claimReward(uint256 amount) public {
        User storage _user = user[msg.sender];
        updateReward();
        uint256 _claimableReward = _user.reward;
        require(_claimableReward >= amount, "insufficient funds");
        _user.reward -= amount;
        if (amount > rewardToken.balanceOf(address(this))) revert tryAgain();
        rewardToken.transfer(msg.sender, amount);
    }

    function updateReward() public {
        User storage _user = user[msg.sender];
        uint256 _reward = calcReward();
        _user.reward += _reward;
        _user.startTime = block.timestamp;
    }

    function withdrawStaked(uint256 amount) public {
        User storage _user = user[msg.sender];
        uint256 staked = _user.stakedAmount;
        require(staked >= amount, "insufficient fund");
        updateReward();
        _user.stakedAmount -= amount;
        stakeToken.transfer(msg.sender, amount);
    }


    function userInfo(address _user) external view returns (User memory) {
        return user[_user];
    }










}