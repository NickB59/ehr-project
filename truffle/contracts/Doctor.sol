// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Patient.sol";

contract Doctor{
    struct DD_T{
        string name;
        string specialization;
        string add;
        uint256 phone;
        string email;
    }

    struct Patient_List_T{
        address patient;
        uint256 date;
    }
    mapping(address => DD_T) doctor_details;
    mapping(address => Patient_List_T[]) patient_list;
    mapping(address => Patient) patients;

    function set_Doctor_Details(string memory name, string memory specialization, string memory add, uint256 phone, string memory email) public{
        doctor_details[msg.sender].name = name;
        doctor_details[msg.sender].specialization = specialization;
        doctor_details[msg.sender].add = add;
        doctor_details[msg.sender].phone = phone;
        doctor_details[msg.sender].email = email;
    }

    function get_Doctor_Details() public view returns(string memory, string memory, string memory, uint256, string memory){
        return (
            doctor_details[msg.sender].name,
            doctor_details[msg.sender].specialization,
            doctor_details[msg.sender].add,
            doctor_details[msg.sender].phone,
            doctor_details[msg.sender].email
        );
    }

    function add_Patient(address patient) public{
        patient_list[msg.sender].push(Patient_List_T(patient, block.timestamp));

    }

    function delete_Patient(address patient) public{
        for (uint256 i = 0; i < patient_list[msg.sender].length; i++) {
            if (
                keccak256(abi.encodePacked(patient_list[msg.sender][i].patient)) ==
                keccak256(abi.encodePacked(patient))
            ) {
                //Deletes the diagnosis from the patient_list. The element that is being deleted is replaced with the next element and this will continue
                //until the end of the array is reached. Then the last element will be deleted since it is a duplicate of the element ahead of it.
                for (uint256 j = i; j < patient_list[msg.sender].length - 1; j++) {
                    patient_list[msg.sender][j] = patient_list[msg.sender][j + 1];
                }
                patient_list[msg.sender].pop();
                return;
            }
        }
    }

    function get_Patient_List() public view returns(Patient_List_T[] memory){
        return patient_list[msg.sender];
    }

    

}