// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BitShieldVault {
    mapping(address => uint256) public collateralAmounts;
    mapping(address => uint256) public debtAmounts;
    
    uint256 public totalTVL;
    uint256 public totalBorrowed;
    uint16 public collateralRatio = 15000; // 150%
    uint256 public btcPrice = 60000_00000000; // $60,000
    address public owner;
    
    event Deposited(address indexed user, uint256 timestamp);
    event Borrowed(address indexed user, uint256 timestamp);
    event Repaid(address indexed user, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 timestamp);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    function depositCollateral(uint256 encryptedAmount) external {
        require(encryptedAmount > 0, "Amount must be positive");
        
        collateralAmounts[msg.sender] += encryptedAmount;
        totalTVL += encryptedAmount;
        
        emit Deposited(msg.sender, block.timestamp);
    }
    
    function borrow(uint256 encryptedAmount) external {
        require(encryptedAmount > 0, "Amount must be positive");
        require(collateralAmounts[msg.sender] > 0, "No collateral");
        
        debtAmounts[msg.sender] += encryptedAmount;
        totalBorrowed += encryptedAmount;
        
        emit Borrowed(msg.sender, block.timestamp);
    }
    
    function repay(uint256 encryptedAmount) external {
        uint256 currentDebt = debtAmounts[msg.sender];
        require(currentDebt >= encryptedAmount, "Repay exceeds debt");
        
        debtAmounts[msg.sender] -= encryptedAmount;
        totalBorrowed -= encryptedAmount;
        
        emit Repaid(msg.sender, block.timestamp);
    }
    
    function withdrawCollateral(uint256 encryptedAmount) external {
        uint256 collateral = collateralAmounts[msg.sender];
        uint256 debt = debtAmounts[msg.sender];
        
        require(collateral >= encryptedAmount, "Insufficient collateral");
        require(debt == 0, "Must repay debt first");
        
        collateralAmounts[msg.sender] -= encryptedAmount;
        totalTVL -= encryptedAmount;
        
        emit Withdrawn(msg.sender, block.timestamp);
    }
    
    function getCollateral(address user) external view returns (uint256) {
        return collateralAmounts[user];
    }
    
    function getDebt(address user) external view returns (uint256) {
        return debtAmounts[user];
    }
    
    function getTVL() external view returns (uint256) {
        return totalTVL;
    }
    
    function getTotalBorrowed() external view returns (uint256) {
        return totalBorrowed;
    }
    
    function getCollateralRatio() external view returns (uint16) {
        return collateralRatio;
    }
    
    function getBtcPrice() external view returns (uint256) {
        return btcPrice;
    }
    
    function updateBtcPrice(uint256 newPrice) external onlyOwner {
        btcPrice = newPrice;
    }
}
