// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PatientDataManagement {
    using SafeERC20 for IERC20;

    // Token interface
    IERC20 public rewardToken;

    // Token rewards per action
    uint256 public constant TOKEN_REWARD = 10 * (10 ** 18); // Assuming token has 18 decimals

    // Mapping to store patient health data
    struct HealthData {
        uint256 timestamp;
        uint256 glucoseLevel;
        string medication;
        string meals;
        string exercise;
    }

    // Mapping to store health data for each patient (address)
    mapping(address => HealthData[]) private patientData;

    // Mapping to track authorized researchers/providers for data access
    mapping(address => mapping(address => bool)) private accessPermissions;

    // Event emitted when health data is logged
    event DataLogged(address indexed patient, uint256 timestamp, uint256 reward);

    // Event emitted when access is granted or revoked
    event AccessUpdated(address indexed patient, address indexed accessor, bool isGranted, uint256 reward);

    // Event emitted when tokens are claimed
    event TokensClaimed(address indexed user, uint256 amount);

    // Constructor to initialize the reward token
    constructor(address _rewardToken) {
        require(_rewardToken != address(0), "Invalid token address");
        rewardToken = IERC20(_rewardToken);
    }

    // Function for patients to log their health data
    function logHealthData(
        uint256 _glucoseLevel,
        string memory _medication,
        string memory _meals,
        string memory _exercise
    ) public {
        HealthData memory newData = HealthData({
            timestamp: block.timestamp,
            glucoseLevel: _glucoseLevel,
            medication: _medication,
            meals: _meals,
            exercise: _exercise
        });
        patientData[msg.sender].push(newData);

        // Reward the patient with tokens
        rewardToken.safeTransfer(msg.sender, TOKEN_REWARD);

        emit DataLogged(msg.sender, block.timestamp, TOKEN_REWARD);
    }

    // Function for patients to grant or revoke access to their data
    function updateAccess(address _accessor, bool _isGranted) public {
        accessPermissions[msg.sender][_accessor] = _isGranted;

        // Reward the patient with tokens for managing permissions
        rewardToken.safeTransfer(msg.sender, TOKEN_REWARD);

        emit AccessUpdated(msg.sender, _accessor, _isGranted, TOKEN_REWARD);
    }

    // Function for authorized users to view a patient's health data
    function viewHealthData(address _patient) public view returns (HealthData[] memory) {
        require(
            _patient == msg.sender || accessPermissions[_patient][msg.sender],
            "Access not authorized"
        );
        return patientData[_patient];
    }

    // Function to claim tokens (if reward system requires accumulation)
    function claimTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient contract balance");

        rewardToken.safeTransfer(msg.sender, amount);
        emit TokensClaimed(msg.sender, amount);
    }

    // Additional feature: Check token balance of the contract
    function contractTokenBalance() public view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }
}
