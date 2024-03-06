// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LendingPlatform {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public debt;
    mapping(address => uint256) public interestRate; // in basis points (1% = 100)
    address[] public users; // Maintain a list of users

    receive() external payable {}
    
    function setInterestRate(uint256 newRate) external {
        require(newRate <= 10000, "Invalid interest rate"); // Maximum 100% interest
        interestRate[msg.sender] = newRate;
    }


    function deposit() external payable {
        deposits[msg.sender] += msg.value;
        // Add user to the list if not already present
        if (deposits[msg.sender] > 0 && debt[msg.sender] == 0) {
            users.push(msg.sender);
        }
    }

    //need to repay to the orignal user
     function totalRepayment(address account) external view returns (uint256) {
        uint256 originalDebt = debt[account];
        require(originalDebt > 0, "No outstanding debt");
        uint256 interest = (originalDebt * interestRate[account]) / 10000;
        return originalDebt + interest;
    }

    function withdraw(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient deposit");
        require(debt[msg.sender] == 0, "Cannot withdraw with outstanding debt");
        require(address(this).balance >= deposits[msg.sender], "Cannot withdraw if someone has borrowed from the lending pool");

        deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        // Remove user from the array if their deposit becomes zero
        if (deposits[msg.sender] == 0) {
            for (uint256 i = 0; i < users.length; i++) {
                if (users[i] == msg.sender) {
                    // Swap with the last element and pop
                    users[i] = users[users.length - 1];
                    users.pop();
                    break;
                }
            }
        }
    }

    function borrow(uint256 amount) external {
        require(debt[msg.sender] == 0, "Already borrowed");
        require(address(this).balance >= amount, "Insufficient funds in the lending pool");
        debt[msg.sender] = amount;
        payable(msg.sender).transfer(amount);
    }

    function repay() external payable {
        uint256 originalDebt = debt[msg.sender];
        require(originalDebt > 0, "No outstanding debt");
        uint256 interest = (originalDebt * interestRate[msg.sender]) / 10000;
        uint256 totalRepaymentAmount = originalDebt + interest;
        require(msg.value >= totalRepaymentAmount, "Insufficient repayment amount");
        debt[msg.sender] = 0;
        interestRate[msg.sender] = 0;
        if (msg.value > totalRepaymentAmount) {
            payable(msg.sender).transfer(msg.value - totalRepaymentAmount);
        }
    }

    function getTotalDeposits() external view returns (uint256) {
        uint256 totalDeposits = 0;

        // Iterate through all users and sum up their deposits
        for (uint256 i = 0; i < users.length; i++) {
            totalDeposits += deposits[users[i]];
        }

        return totalDeposits;
    }

    function getUserCount() external view returns (uint256) {
        return users.length;
    }

    function getUserAtIndex(uint256 index) external view returns (address) {
        require(index < users.length, "Index out of bounds");
        return users[index];
    }

    function getAllUsersWithDeposits() external view returns (address[] memory, uint256[] memory) {
    uint256 userCount = users.length;
    address[] memory allUsers = new address[](userCount);
    uint256[] memory userDeposits = new uint256[](userCount);

    for (uint256 i = 0; i < userCount; i++) {
        address user = users[i];
        allUsers[i] = user;
        userDeposits[i] = deposits[user];
    }

    return (allUsers, userDeposits);
}
}
