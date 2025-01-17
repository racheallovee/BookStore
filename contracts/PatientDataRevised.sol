// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientDataManagement {
    // Token rewards per action
    uint256 public constant TOKEN_REWARD = 10;

    // Mapping to store patient health data
    struct HealthData {
        uint256 timestamp;
        uint256 glucoseLevel;
        string medication;
        string meals;
        string exercise;
    }

    // ERC20-like token balance mapping
    mapping(address => uint256) public tokenBalances;

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
        tokenBalances[msg.sender] += TOKEN_REWARD;

        emit DataLogged(msg.sender, block.timestamp, TOKEN_REWARD);
    }

    // Function for patients to grant or revoke access to their data
    function updateAccess(address _accessor, bool _isGranted) public {
        accessPermissions[msg.sender][_accessor] = _isGranted;

        // Reward the patient with tokens for managing permissions
        tokenBalances[msg.sender] += TOKEN_REWARD;

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

    // Function to claim tokens
    function claimTokens() public {
        uint256 amount = tokenBalances[msg.sender];
        require(amount > 0, "No tokens to claim");

        tokenBalances[msg.sender] = 0;
        // Logic to transfer tokens can be added here

        emit TokensClaimed(msg.sender, amount);
    }
}
