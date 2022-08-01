// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Patient {
    struct PD_T {
        string name;
        uint256 age;
        string add;
        uint256 mobile;
        string email;
    }
    struct History_T {
        string diagnosis;
        string treatment;
        string medicine;
        uint256 date;
    }

    mapping(address => PD_T) Personal_Details;
    mapping(address => History_T[]) History;

    function set_Personal_Details(
        string memory name,
        uint256 age,
        string memory add,
        uint256 mobile,
        string memory email
    ) public {
        Personal_Details[msg.sender].name = name;
        Personal_Details[msg.sender].age = age;
        Personal_Details[msg.sender].add = add;
        Personal_Details[msg.sender].mobile = mobile;
        Personal_Details[msg.sender].email = email;
    }

    function get_Personal_Details()
        public
        view
        returns (
            string memory,
            uint256,
            string memory,
            uint256,
            string memory
        )
    {
        return (
            Personal_Details[msg.sender].name,
            Personal_Details[msg.sender].age,
            Personal_Details[msg.sender].add,
            Personal_Details[msg.sender].mobile,
            Personal_Details[msg.sender].email
        );
    }

    function set_History(
        string memory diagnosis,
        string memory treatment,
        string memory medicine,
        uint256 date
    ) public {
        //Checks to see if diagnosis exists in the history. If it does not, it adds the new treatment to the end of the array.
        for (uint256 i = 0; i < History[msg.sender].length; i++) {
            if (
                keccak256(abi.encodePacked(History[msg.sender][i].diagnosis)) ==
                keccak256(abi.encodePacked(diagnosis))
            ) {
                History[msg.sender][i].treatment = treatment;
                History[msg.sender][i].medicine = medicine;
                History[msg.sender][i].date = date;
                return;
            }
        }
        History[msg.sender].push(
            History_T(diagnosis, treatment, medicine, date)
        );
    }

    function get_History(string memory diagnosis)
        public
        view
        returns (
            string memory,
            string memory,
            uint256
        )
    {
        for (uint256 i = 0; i < History[msg.sender].length; i++) {
            if (
                keccak256(abi.encodePacked(History[msg.sender][i].diagnosis)) ==
                keccak256(abi.encodePacked(diagnosis))
            ) {
                return (
                    History[msg.sender][i].treatment,
                    History[msg.sender][i].medicine,
                    History[msg.sender][i].date
                );
            }
        }
        return ("", "", 0);
    }

    function get_Full_History() public view returns (History_T[] memory) {
        return History[msg.sender];
    }

    function delete_History(string memory diagnosis) public {
        //Checks to see if diagnosis exists in the history. If it does, it deletes the diagnosis from the history.
        for (uint256 i = 0; i < History[msg.sender].length; i++) {
            if (
                keccak256(abi.encodePacked(History[msg.sender][i].diagnosis)) ==
                keccak256(abi.encodePacked(diagnosis))
            ) {
                //Deletes the diagnosis from the history. The element that is being deleted is replaced with the next element and this will continue
                //until the end of the array is reached. Then the last element will be deleted since it is a duplicate of the element ahead of it.
                for (uint256 j = i; j < History[msg.sender].length - 1; j++) {
                    History[msg.sender][j] = History[msg.sender][j + 1];
                }
                History[msg.sender].pop();
                return;
            }
        }
    }
}
