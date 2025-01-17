// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientDataManagement {
    // Structure to store patient health data
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
    event DataLogged(address indexed patient, uint256 timestamp);

    // Event emitted when access is granted or revoked
    event AccessUpdated(address indexed patient, address indexed accessor, bool isGranted);

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
        emit DataLogged(msg.sender, block.timestamp);
    }

    // Function for patients to grant or revoke access to their data
    function updateAccess(address _accessor, bool _isGranted) public {
        accessPermissions[msg.sender][_accessor] = _isGranted;
        emit AccessUpdated(msg.sender, _accessor, _isGranted);
    }

    // Function for authorized users to view a patient's health data
    function viewHealthData(address _patient) public view returns (HealthData[] memory) {
        require(
            _patient == msg.sender || accessPermissions[_patient][msg.sender],
            "Access not authorized"
        );
        return patientData[_patient];
    }
}
