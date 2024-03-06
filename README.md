# lending_platform_blkchn_eth
DeFi Simple Lending Platform based on Ethereum Blockchain Smart Contract
# LendingPlatform Smart Contract Documentation

## Functions

### `setInterestRate(uint256 newRate) external`

- **Description:** Sets the interest rate for the caller's account.
- **Parameters:**
  - `newRate`: The new interest rate in basis points (1% = 100).
- **Requirements:**
  - The caller must provide a valid interest rate (up to 10000, representing 100%).

### `deposit() external payable`

- **Description:** Allows users to deposit Ether into the lending pool.
- **Requirements:**
  - Users can only deposit if they have no outstanding debt.
  - Adds the user to the list if they are not already present.

### `totalRepayment(address account) external view returns (uint256)`

- **Description:** Calculates the total repayment amount for a given account, including interest.
- **Parameters:**
  - `account`: The address for which to calculate the total repayment.
- **Requirements:**
  - The account must have an outstanding debt.

### `withdraw(uint256 amount) external`

- **Description:** Allows users to withdraw deposited funds from the lending pool.
- **Parameters:**
  - `amount`: The amount to withdraw.
- **Requirements:**
  - Users cannot withdraw if they have an outstanding debt.
  - Users cannot withdraw if someone has borrowed from the lending pool.

### `borrow(uint256 amount) external`

- **Description:** Allows users to borrow funds from the lending pool.
- **Parameters:**
  - `amount`: The amount to borrow.
- **Requirements:**
  - Users cannot borrow if they already have an outstanding debt.
  - The lending pool must have sufficient funds.

### `repay() external payable`

- **Description:** Allows users to repay their outstanding debt, including interest.
- **Requirements:**
  - Users must have an outstanding debt.
  - The repayment amount must be sufficient to cover the debt.

### `getTotalDeposits() external view returns (uint256)`

- **Description:** Retrieves the total value of deposits in the lending pool.

### `getUserCount() external view returns (uint256)`

- **Description:** Retrieves the total number of users in the lending pool.

### `getUserAtIndex(uint256 index) external view returns (address)`

- **Description:** Retrieves the user address at a specific index in the user list.
- **Parameters:**
  - `index`: The index of the user to retrieve.

### `getAllUsersWithDeposits() external view returns (address[] memory, uint256[] memory)`

- **Description:** Retrieves all users along with their corresponding deposit amounts.

## Usage

1. **Setting Interest Rate:**
   - Call `setInterestRate` to set the interest rate for your account.

2. **Depositing Funds:**
   - Deposit Ether into the lending pool using the `deposit` function.

3. **Borrowing Funds:**
   - Borrow funds from the lending pool using the `borrow` function.

4. **Repaying Debt:**
   - Repay your outstanding debt using the `repay` function.

5. **Withdrawing Funds:**
   - Withdraw deposited funds from the lending pool using the `withdraw` function.

6. **Retrieve User Information:**
   - Use `getUserCount`, `getUserAtIndex`, and `getAllUsersWithDeposits` to retrieve user information.

## Notes

- Users cannot withdraw funds if they have an outstanding debt or if someone has borrowed from the lending pool.
- Interest rates are set individually for each user.
- Users are removed from the list when their deposit becomes zero.
